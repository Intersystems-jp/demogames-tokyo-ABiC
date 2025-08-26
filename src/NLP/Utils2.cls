Class NLP.Utils2
{

/// ダッシュボードのベースURL
/// Parameter baseurl = "https://ec2-52-194-192-117.ap-northeast-1.compute.amazonaws.com/csp/user/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=";
Parameter baseurl = "https://localhost:7443/csp/user/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=";

/// in : 生成AIから得たJSON
/// {
///  "cube": "ABiCAttendanceCube",
///  "measures": [
///    {
///      "name": "%COUNT",
///      "mdx": "[Measures].[%COUNT]"
///    }
///  ],
///  "dimensions": [
///    {
///      "name": "EmpRole",
///      "mdx": "[EmpRole].[H1].[EmpRole]"
///    },
///    {
///      "name": "ShiftName",
///      "mdx": "[ShiftName].[H1].[ShiftName]"
///    },
///    {
///      "name": "DateOfEx",
///      "mdx": "[DateOfEx].[H1]"
///    }
///  ],
///  "filters": {
///    "DateOfEx": { "Year": 2024, "Month": 4 },
///    "mdx_where": [
///      "[DateOfEx].[H1].[Year].&[2024]",
///      "[DateOfEx].[H1].[Month].&[4]"
///    ]
///  },
///  "group_by": [
///    { "name": "EmpRole", "mdx": "[EmpRole].[H1].[EmpRole]" },
///    { "name": "ShiftName", "mdx": "[ShiftName].[H1].[ShiftName]" }
///  ]
/// }
/// 
ClassMethod Run(input As %String(MAXLEN=""), APIKey As %String(MAXLEN="")) As %String(MAXLEN="")
{
    #dim ex As %Exception.AbstractException
    try {
        //************
        //set start=$ZH
        //************
        set ^iijima=input
        //どうしても先頭にJSON以外の文字列を付けるのでカットする、
        set input=$EXTRACT(input,$FIND(input,"{")-1,*)
        set in={}.%FromJSON(input) 
        //pivot作成
        set num=$increment(^ABiC("pivotNum"))
        set pivotname="ABiCPivot"_num
        set ^ABiC("pivotName",num)=pivotname_"^"_in.cube
        $$$ThrowOnError(..createPivot(.in,pivotname))
        
        //filter作成
        if $ISOBJECT(in.%Get("filters")) && ($ISOBJECT(in.%Get("filters")."mdx_where")) {
            set iter=in.filters."mdx_where".%GetIterator()
            while iter.%GetNext(.key,.val) {
                if val["Year" {
                    set yearfilt=$piece(val,".",$length(val,"."))
                }
                else {
                    set monthfilt=$piece(val,".",$length(val,"."))
                }
            }
            set mdxwhere=in.filters."mdx_where"
        }
        //Dashboard作成準備
        if '$data(^ABiC("dashName")) { 
            set num=$increment(^ABiC("DashNum"))
            set dashname="ABiCDash"_num
            set ^ABiC("dashName",num)=dashname
        }
        else {
            set dashname=^ABiC("dashName",$Get(^ABiC("DashNum")))
        }
        //作成済pivotがあったらそれを追加する
        set exnum=""
        for {
            set exnum=$order(^ABiC("pivotName",exnum),1,expivot)
            if exnum="" quit
            set p($PIECE(expivot,"^",1))=$PIECE(expivot,"^",2)
        }
        //今回作成したピボットを追加
        // p(pivotname)=cube名
        set p(pivotname)=in.cube
        
        /*KPI追加をやめる*/
        //if $get(^ABiC("pivotNum"))=2 {
            // KPI追加する
            //set p("kpipivot")="SQLBaseKPI.kpi"
            /*
            set num=$increment(^ABiC("pivotNum"))
            set ^ABiC("pivotName",num)="SQLBaseKPI.kpi"
            */
        //}
        
        //************
        //zw p,dim,measure,d,monthfilt,yearfilt
        //************
        if $get(yearfilt)'="" || ($get(monthfilt)'="") {
            set DateOfEx=1
        }
        else {
            set DateOfEx=0
        }
        $$$ThrowOnError(..createDashboard(.p,dashname,DateOfEx,1,$get(yearfilt),$get(monthfilt),1))
        set url=..#baseurl_dashname_".dashboard&NOTITLE=1"
        set ^iijima("url")=url
        set j={}
        set j.url=url

        //作成できたピボットからMDX式と結果をJSONに出し、サマリとレコメンドをOpenAIに聞く
        set mdxwhere=in.filters."mdx_where"
        $$$ThrowOnError(..getRecommend(APIKey,pivotname,mdxwhere,.openairesponse))
        if $ISOBJECT(openairesponse) {
            // 実行時のトークン数をオーバーするとmessage直下にメッセージが来る
            if $ISOBJECT(openairesponse.choices) {
                set j.recommend=openairesponse.choices.%Get(0).message.content
            }
            else {
                set j.recommend="OpenAI ERROR: "_openairesponse.error.message
            }
        }
        //************
        //set end=$ZH
        //write "実行時間：",end-start,!
        //************

        set returnJson=j.%ToJSON()
        /*
        set j.explain="💡 After changing to pivot window, select a cell and click on the binoculars button to see the original data of the analysis results."
        set:$data(p("kpipivot")) j.recommend="👍 Do you need to check your inventory data? I put the pivot in your dashboard."
        //set returnjson=j.%ToJSON()
        // Adaptive Card作成
        set facts1=##class(NLP.CardFacts).%New()
        set card=##class(NLP.Card).%New()
        set facts1.Key="How to use it: "
        set facts1.Value=j.explain
        do card.Facts.Insert(facts1)
        if j.recommend'="" {
            set facts2=##class(NLP.CardFacts).%New()
            set facts2.Key="Recommend: "
            set facts2.Value=j.recommend
            do card.Facts.Insert(facts2)
        } 
        set card.createDate=$ZDATE(+$H)
        set card.URL=url
        $$$ThrowOnError(card.OutputToDynamicObject(.returnJson))

        return returnJson.%ToJSON()
        */
    }
    catch ex {
        set j={}
        set j.Error="Error:"_ex.DisplayString()
        set returnJson=j.%ToJSON()
    }
    set ^iijima("ret")=returnJson
    return returnJson
}

/// /src/wsgi/config.pyに記載しているサマリとレコメンド取得用システムプロンプト取得
ClassMethod getSystemPrompt() As %String(MAXLEN="")
{
    set sys=##class(%SYS.Python).Import("sys")
    do sys.path.append("/src/wsgi")
    set config=##class(%SYS.Python).Import("config")
    return config.forSummary
}

/// 作成できたピボットからMDX式と結果をJSONで入手し、OpenAIに問い合わせる
/// 第1引数：ピボット名
/// 第2引数：filterがあれば、mdx_whereのJSON配列（ダイナミックオブジェクト）
/// 第3引数：OpenAIからのHTTP応答
ClassMethod getRecommend(APIKey As %String(MAXLEN=""), pivot As %String, ByRef mdxwhere As %DynamicArray, ByRef response As %DynamicArray) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        if $get(pivot)="" {
            throw ##class(%Exception.General).%New("ABiC-PivotError",5001,,"Pivotが指定されていません")
        }
        // IRISにPOST要求実行：PivotのMDX式と結果を取得する
        set server="abicWG"
        set port=80
        set location="/api/deepsee/v3/user/Data/PivotExecute"
        set body={}
        set body.PIVOT=pivot
        if $ISOBJECT(mdxwhere) {
            set body.FILTERS=mdxwhere
        }
        $$$ThrowOnError(..POSTRequest(server,location,port,,.body,.response))
        set ^iijima("get-recommend-iris-mdx-result")=response.%ToJSON()

        //OpenAIへの送信メッセージの準備
        set sendjson={}
        set sendjson.model="gpt-4o"
        set sendjson.messages=[]
        set prompt={}
        set prompt.role="system"
        set prompt.content=##class(NLP.Utils2).getSystemPrompt()
        do sendjson.messages.%Push(prompt)
        set prompt={}
        set prompt.role="user"
        set prompt.content=response.%ToJSON()
        do sendjson.messages.%Push(prompt)
        //OpenAIに結果のサマリと次の分析文を作ってもらう
        // IRISにPOST要求実行：PivotのMDX式と結果を取得する
        set server="api.openai.com"
        set port=443
        set location="/v1/chat/completions"
        set key=APIKey
        $$$ThrowOnError(..POSTRequest(server,location,port,key,.sendjson,.response))
        set ^iijima("get-recommend-openai")=response.%ToJSON()
    }
    catch ex {
        set status=ex.AsStatus()
        set ^iijima("get-recommend-err")=ex.DisplayString()
    }
    return status
}

ClassMethod POSTRequest(server As %String, location As %String, port As %Integer, key As %String(MAXLEN=1000), ByRef body As %DynamicArray, ByRef response As %DynamicArray) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        set req=##class(%Net.HttpRequest).%New()
        set req.Server=server
        if server="abicWG" {
            set base64=$SYSTEM.Encryption.Base64Encode("_system:SYS")
            do req.SetHeader("Authorization","Basic "_base64)
        }
        if $Get(key)'="" {
            //OpenAIを想定
            do req.SetHeader("Authorization","Bearer "_key)
        }
        set req.Location=location
        if port'=80 {
            set req.SSLConfiguration="webapi"
            set req.Https=1
        }
        set req.ContentType="application/json"
        set req.ContentCharset="utf-8"
        // Body
        do body.%ToJSON(req.EntityBody)
        $$$ThrowOnError(req.Post())
        set response={}.%FromJSON(req.HttpResponse.Data)
    }
    catch ex {
        set status=ex.AsStatus()
        set ^iijima("get-recommend-err")=ex.DisplayString()
    }
    return status
}

/// ダッシュボード作成
/// ピボットテーブル表示とする。DateOfExがある場合はフィルタにYearとMonthを置くようにする
/// pivots ピボット名を第1サブスクリプトに入れて渡す
///     pivots("t1")=""
///     pivots("t2")=""
/// dash ダッシュボード名
/// 同名のダッシュボードがある場合は削除してから作成する
/// Yearのフィルタの値を指定できるようにした：&[2024]
/// Monthのフィルタの値を指定：&[12] など
ClassMethod createDashboard(ByRef pivots As %String, dash As %String, DateOfEx As %Boolean = 0, Dept As %Boolean = 0, YearFilt As %String = "", MonthFilt As %String = "", Listing As %Boolean = 0) As %Status
{
    set status=$$$OK
    try {
        if ##class(%DeepSee.Dashboard.Utils).%DashboardExists(dash_".dashboard")'=0 {
            set flg=##class(%DeepSee.Dashboard.Utils).%DeleteDashboard(dash_".dashboard")
            if flg=0 {
                throw ##class(%Exception.General).%New("Dashborad削除エラー",5001,,dash_"を削除できませんでした")
            }
        }
        // ダッシュボード作成
        set d=##class(%DeepSee.Dashboard.Definition).%New()
        set d.createdBy="SuperUser"
        set d.name=dash
        /* snapGridとsnapToないと表示されない*/
        set d.snapGrid=1
        set d.snapTo=1
        set d.worklistCount=1
        //widgets登録
        set pname="",num=1,(homeR,homeC)=0,colS=5,rowS=4
        for {
            set pname=$ORDER(pivots(pname),1,cubename)
            if pname="" quit
            set w=##class(%DeepSee.Dashboard.Widget).%New()
            set w.name=pname
            set w.type="pivot"
            set w.subtype="pivot"
            set w.title=pname
            set w.subtypeClass="lineChart"
            set w.width=300
            set w.height=200
            // 何個目かのピボットで場所を変更
            if num>1 {
                //2で割って余り1の時                 
                if num#2 {
                    set homeR=homeR+rowS
                    set homeC=0
                    set colS=5
                }
                else {
                    set homeR=homeR
                    set rowS=4
                    set homeC=homeC+colS
                }
            }
            set w.homeRowL=homeR
            set w.homeColL=homeC
            set w.colSpanL=colS
            set w.rowSpanL=rowS
            if cubename[".kpi" {
                set w.dataSource=cubename
                set w.name="StockInfo"  //渡ってくるのは"kpipivot"なのでKPIはStockInfoとする
                // ウィジェットにフィルタを付ける
                set c1=##class(%DeepSee.Dashboard.Control).%New()
                set c1.action="applyFilter"
                set c1.label="Year"
                set c1.location="widget"
                set c1.targetProperty="Year"
                do w.controls.Insert(c1)
                set c2=##class(%DeepSee.Dashboard.Control).%New()
                set c2.action="applyFilter"
                set c2.label="Month"
                set c2.location="widget"
                set c2.targetProperty="Month"
                do w.controls.Insert(c2)
                set c3=##class(%DeepSee.Dashboard.Control).%New()
                set c3.action="ShowAreaInfo"
                set c3.label="ShowAreaInfo"
                set c3.location="widget"
                set c3.type="auto"
                do w.controls.Insert(c3)
            }
            else {
                set w.dataSource=pname_".pivot"
            }
            //controls登録
            //既にあれば付けない
            //if (num=1)&&(DateOfEx=1) {
            if DateOfEx=1&&($get(DateOfExExisting)="") {
                set c1=##class(%DeepSee.Dashboard.Control).%New()
                set c2=##class(%DeepSee.Dashboard.Control).%New()
                set c1.action="applyFilter"
                set c2.action="applyFilter"
                set c1.targetProperty="[DateOfEx].[H1].[Year]"
                set c1.label="Year"
                set c2.targetProperty="[DateOfEx].[H1].[Month]"
                set c2.label="Month"
                set c1.location="dashboard"
                set c2.location="dashboard"
                set c1.target="*"
                set c2.target="*"
                set c1.value=YearFilt
                set c2.value=MonthFilt
                do w.controls.Insert(c1)
                do w.controls.Insert(c2)
                set DateOfExExisting=1
            }
            //if (num=1)&&(Dept=1) {
            if Dept=1 &&($get(DeptExisting)=""){
                set c3=##class(%DeepSee.Dashboard.Control).%New()
                set c3.action="applyFilter"
                set c3.targetProperty="[Department].[H1].[Department]"
                set c3.label="Department"
                set c3.location="dashboard"
                set c3.target="*"
                do w.controls.Insert(c3)
                set DeptExisting=1
            }
            // 詳細リストを付ける場合
            //Cube名から詳細リストを取得し、ある分だけウィジェットにコントロールとして設定
            if (Listing=1)&&(cubename'[".kpi") {
                $$$ThrowOnError(##class(%DeepSee.Utils).%GetCubeListings(cubename,.listing))
                set lcn=""
                for {
                    set lcn=$Order(listing(lcn))
                    if lcn="" quit
                    set clisting=##class(%DeepSee.Dashboard.Control).%New()
                    set clisting.action="showListing"
                    set clisting.targetProperty=lcn
                    set clisting.label=lcn
                    set clisting.location="widget"
                    set clisting.type="auto"
                    set clisting.activeWhen="itemSelected"
                    do w.controls.Insert(clisting)
                }
            }
            kill cubename
            do d.widgets.Insert(w)
            set num=num+1
        }
        $$$ThrowOnError(d.%Save())
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

/// 《ピボット作成方法》
/// %DeepSee.Dashboard.Pivotのインスタンス生成
///  cubeNameにキューブ名設定
///  name にピボット名指定（拡張子いらない） 
///  rowLevelsにディメンジョンの内容入ってる（リスト）
/// 　　rowLevelsのインスタンスは %DeepSee.Dashboard.PivotLevel のインスタンス
///     　text　にレベル表示名
///     　spec にMDX式
///     CROSSJOINしてる場合はchildLevelsを使う
///         childLevelsプロパティもリスト、タイプは%DeepSee.Dashboard.PivotLevel
///         textにレベル表示名
///         specにMDX式
///     do rowLevels.Insert(作ったインスタンス)　で設定する
///  MeasureはPivotクラスのmeasures（リスト）%DeepSee.Dashboard.PivotLevel
///     textに表示名
///     specにMDX式
/// ==============================================================
/// 第１位引数：ディメンジョン
///     添え字にMDX（"row or col",[xx].Members など） データ部は表示名
///     第１レベルのみの場合
///         dimentions("row","[xx].Members")="表示名"  ->行指定
///         dimentions("col","[xxx].Members")="表示名"  -> 列指定
///     子レベルを持つ場合
///         dimentions("row","[xx].Members","[childxx].Members")="表示名"
///     添え字の階層通りに子レベルとして設定する
/// 第2引数：メジャーのみ
///     measure("[xx]")="表示名"
/// 第3引数：キューブ名
/// 第4引数：作成するピボット名（既存名あっても保存可能だけど既存残る）
ClassMethod createPivot(in As %DynamicArray, pivotname As %String = "try9") As %Status
{
    set status=$$$OK
    try {
        //同じピボット名が存在してるかチェックし、存在してれば削除
        do ..deleteSameNamePivot(pivotname)
        set p=##class(%DeepSee.Dashboard.Pivot).%New()
        set p.createdBy="SuperUser"
        set p.name=pivotname
        set p.cubeName=in.cube

        //ディメンジョンの設定
        set dimentions=in.dimensions
        do ..SetLevel(.dimentions,.p)
        
        //メジャー設定
        set iter=in.measures.%GetIterator()
        //メジャーが複数ある時はCOUNTを除く
        while iter.%GetNext(.key,.val) {
            set m=##class(%DeepSee.Dashboard.PivotLevel).%New()
            set m.text=val.name
            set m.spec=val.mdx
            if val.name="%COUNT" {
                set countari=key+1
            }
            do p.measures.Insert(m)      
        }
        if key>0 && ($get(countari)'="") {
            do p.measures.RemoveAt(countari)
        }
        $$$ThrowOnError(p.%Save())
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

/// name : ピボット名（拡張子なし）
ClassMethod deleteSameNamePivot(name As %String) As %Status
{
    set status=$$$OK
    try {
        set sql="select ID FROM %DeepSee_Dashboard.Pivot where name=?"
        set stmt=##class(%SQL.Statement).%New()
        $$$ThrowOnError(stmt.%Prepare(sql))
        set rset=stmt.%Execute(name)
        while rset.%Next() {
            set id=rset.ID
            &sql(delete from %DeepSee_Dashboard.Pivot where ID=:id)
            if SQLCODE<0 {
                throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
            }
        }
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

/// dimentions：以下、%DynamicArrayが渡る
///   "dimensions": [
///    {
///      "name": "EmpRole",
///      "mdx": "[EmpRole].[H1].[EmpRole]"
///    },
///    {
///      "name": "ShiftName",
///      "mdx": "[ShiftName].[H1].[ShiftName]"
///    },
///    {
///      "name": "DateOfEx",
///     "mdx": "[DateOfEx].[H1]"
///    }
///  ]
/// pivot：ピボットのインスタンス
/// 
/// ピボット作成時
///     　text　にレベル表示名
///     　spec にMDX式
ClassMethod SetLevel(ByRef dimentions As %String, ByRef pivot As %DeepSee.Dashboard.Pivot)
{
    set iter=dimentions.%GetIterator()

    // ディメンジョン２個目がきたら１個目の子に。３個目以降は列にする
    set cn=1
    while iter.%GetNext(.key,.val) {
        // %DeepSee.Dashboard.PivotLevelのインスタンス生成
        set level(cn)=##class(%DeepSee.Dashboard.PivotLevel).%New()
        set level(cn).spec=val.mdx
        set level(cn).text=val.name
        set cn=cn+1
        /*
        //0番目は行に追加
        if key=0 {
            do pivot.rowLevels.Insert(level(0))
        }
        //1番目は0番目の子レベルとして追加
        if key=1 {
            do level(0).childLevels.Insert(level(1))
            do pivot.rowLevels.RemoveAt(1) // 1個前に入れたrowの内容を一旦削除
            do pivot.rowLevels.Insert(level(0))
        }
        if key>2 {
            do pivot.columnLevels.Insert(level(key))
        }
        */
    }
    // levelの添え字の分だけrowとcolに設定
    set k=""
    for {
        set k=$order(level(k),1,data)
        if k="" { quit }
        if k=1 {
            do pivot.rowLevels.Insert(data)
            continue
        }
        if (k=2) && (cn>=2) {
            do level(1).childLevels.Insert(data)
            continue
        }
        #;残りはcol
        else {
            do pivot.columnLevels.Insert(level(k))
        }
    }
}

/// 作成したダッシュボード、ピボットの削除
/// Delete ABiC dashboards and pivots.
ClassMethod ABiCDelete() As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        write "作成したダッシュボードとピボットを消します（Delete ABiC dashboards and pivots.）",!
        set cn=""
        for {
            set cn=$ORDER(^ABiC("dashName",cn),1,data)
            if cn="" quit
            set fullname=data_".dashboard"
            $$$ThrowOnError(##class(%DeepSee.UserLibrary.Utils).%DeleteFolderItem(fullname,.count))
            kill data
        }
        set cn=""
        for {
            set cn=$ORDER(^ABiC("pivotName",cn),1,data)
            if cn="" quit
            set fullname=$piece(data,"^",1)_".pivot"
            $$$ThrowOnError(##class(%DeepSee.UserLibrary.Utils).%DeleteFolderItem(fullname,.count))
            kill data
        }
        if $$$ISOK(status) {
            kill ^ABiC
        }
    }
    catch ex {
        set status=ex.AsStatus()
    }
    return status
}

/// 第1引数：キューブ名をカンマ区切りで指定
///     ABiCAttendanceCube,ABiCClinicDataCube,ABiCConsecutiveDayCube,ABiCIncidentReportCube,MaterialTransaction
/// 第2引数：参照渡しでダイナミックオブジェクトを受け取る変数を指定
ClassMethod GetCubeInfo(input As %Integer = "ABiCAttendanceCube,ABiCClinicDataCube,ABiCConsecutiveDayCube,ABiCIncidentReportCube,MaterialTransaction", ByRef resultjson As %String) As %Status
{
    #dim ex As %Exception.AbstractException
    set status=$$$OK
    try {
        //Measureの取り出しURL
        //https://localhost:7443/api/deepsee/v3/user/Info/Measures/MaterialTransaction

        //Dimensionの取り出しは以下メソッド
        //w ##class(%DeepSee.Utils).%GetDimensionList("MaterialTransaction",.pinfo)
        //Listingの取り出しは以下
        //https://localhost:7443/api/deepsee/v3/user/Info/Listings/MaterialTransaction
        /* json の仕様
        {
            [
                "Cube": "名称",
                "Measures":[
                    メジャー情報
                ],
                "Dimensions":[
                    "name":"Department",
                    "hierarchies":{
                        "name":"H1"
                        "levels":[
                            "Year",
                            "Month",
                            "Year"
                        ]
                    }
                ],
                "Listings":[
                ]
        }
        */
        set resultjson=[]
        set request=##class(%Net.HttpRequest).%New()
        set request.Server="abicWG"
        set request.Port=80
        set base64=$SYSTEM.Encryption.Base64Encode("_system:SYS")
        do request.SetHeader("Authorization","Basic "_base64)
        set baseurl="/api/deepsee/v3/user/Info/"
        for i=1:1:$length(input,",") {
            set cube=$piece(input,",",i)
            set cubejson={}
            set cubejson.Cube=cube
            set cubejson.Dimensions=[]
            // Measures取得
            set cubejson.Measures=[]
            do request.SetHeader("Authorization","Basic "_base64)
            set request.Location=baseurl_"Measures/"_cube
            $$$ThrowOnError(request.Get())
            set response=request.HttpResponse
            set rjson={}.%FromJSON(response.Data)
            //do rjson.Result.Measures.%ToJSON()
            do cubejson.Measures.%Push(rjson.Result.Measures)

            //Dimensions取得
            $$$ThrowOnError(##class(%DeepSee.Utils).%GetDimensionList(cube,.dinfo))
            set (d1,d2,d3,data)=""
            for {
                set d1=$order(dinfo(d1))
                if d1="" { quit }
                for {
                    set d2=$order(dinfo(d1,d2))
                    if d2="" {quit}
                    set dim=[]
                    for {
                        set d3=$order(dinfo(d1,d2,d3),1,data)
                        if d3="" {quit}
                        if $list(data,1)="l" {
                            set dimobj={},dimobj.List=[]
                            set dimobj.Name=$LIST(data,2)
                            set dimobj.Hierarchy=$LIST(data,3)
                            do dimobj.List.%Push($LIST(data,4))
                            do dim.%Push(dimobj)
                        }
                    }
                    if dim.%Size()>0 {
                        do cubejson.Dimensions.%Push(dim)
                    }
                }
            }
            do resultjson.%Push(cubejson)
        }
    }
    catch ex {
        write ex.DisplayString(),!
        set status=ex.AsStatus()
    }
    return status
}

}
