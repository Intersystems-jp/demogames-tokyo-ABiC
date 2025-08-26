Class NLP.Utils
{

/// ダッシュボードのベースURL
/// Parameter baseurl = "https://localhost:9443/csp/user/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=";
Parameter baseurl = "https://ec2-52-194-192-117.ap-northeast-1.compute.amazonaws.com/csp/user/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=";

/// Word,Column,MDXColumn,TableName,Cube,Expression
ClassMethod loadcsv()
{
    &sql(
        LOAD DATA FROM FILE '/opt/src/data/NLP/metainfo.csv'
        INTO NLP.MetaInfo (Word,Column,MDXColumn,TableName,CubeName,Expression)
        USING {"from":{"file":{"charset":"UTF-8","header":true}}}
    )
}

/// マルチリンガルモデル用
ClassMethod Vector()
{
    set select="select ID,Word From NLP.MetaInfo"
    set stmt1=##class(%SQL.Statement).%New()
    set st=stmt1.%Prepare(select)
    set rset1=stmt1.%Execute()
    set stmt2=##class(%SQL.Statement).%New()
    // マルチリンガルモデル
    set st=stmt2.%Prepare("UPDATE NLP.MetaInfo set WordVec=(TO_VECTOR(EMBEDDING(?,'my-sentenceTransformer-config'),DOUBLE,384)) WHERE ID=?")
    while rset1.%Next() {
        set rset2=stmt2.%Execute(rset1.Word,rset1.ID)
        if rset2.%SQLCODE<0 {
            write rset2.%Message,!
        }
    }
}

/// 入れ忘れたとき
ClassMethod WordAdd(w As %String, c As %String = "", mdx As %String, t As %String = "", cube As %String, expression As %String(MAXLEN=500))
{
    set sql="insert into NLP.MetaInfo (Word,Column,MDXColumn,TableName,Cube,Expression,WordVec) VALUES(?,?,?,?,?,?,TO_VECTOR(EMBEDDING(?,'my-sentenceTransformer-config'),DOUBLE,384))"
    set stmt=##class(%SQL.Statement).%New()
    set st=stmt.%Prepare(sql)
    if $$$ISERR(st) {
        write $SYSTEM.Status.GetErrorText(sql),!
        return
    }
    set rset=stmt.%Execute(w,c,mdx,t,cube,expression,w)
    if rset.%SQLCODE<0 {
        write rset.%Message,!
    }
}

/// Wordの中身が違うな・・と思ったときの修正ロジック（マルチリンガルモデル用）
ClassMethod WordUpdate(word As %String, new As %String)
{
    set stmt=##class(%SQL.Statement).%New()
    set status=stmt.%Prepare("select ID from NLP.MetaInfo where Word=?")
    set rset=stmt.%Execute(word)
    do rset.%Next()
    set id=rset.ID
    &sql(start transaction)
    &sql(UPDATE NLP.MetaInfo SET Word=:new WHERE ID=:id)
    if SQLCODE<0 {
        write %msg,!
        &sql(rollback)
        return
    }
    // Vector化
    &sql(
        UPDATE NLP.MetaInfo
         set WordVec=(TO_VECTOR(EMBEDDING(:new,'my-sentenceTransformer-config'),DOUBLE,384))WHERE ID=:id
    )
    if SQLCODE<0 {
        write %msg,!
        &sql(rollback)
        write "更新はなかったことに",!
        return
    }
    write "うまくいきました",!
    &sql(commit)
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
        // ワークリストの設定（フィルタがダッシュボードについてるので付ける時は1に）
        set d.worklistCount=0
        set d.createdBy="SuperUser"
        set d.name=dash
        /* snapGridとsnapToないと表示されない*/
        set d.snapGrid=1
        set d.snapTo=1
        //widgets登録
        set pname="",num=1,(homeR,homeC)=0,colS=5,rowS=5
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
            set w.height=300
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
                    set rowS=5
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
                do w.properties.SetAt("chart","chartToggle")
            }
            //controls登録
            if (num=1)&&(DateOfEx=1) {
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
            }
            if (num=1)&&(Dept=1) {
                set c3=##class(%DeepSee.Dashboard.Control).%New()
                set c3.action="applyFilter"
                set c3.targetProperty="[Department].[H1].[Department]"
                set c3.label="Department"
                set c3.location="dashboard"
                set c3.target="*"
                do w.controls.Insert(c3)
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
ClassMethod createPivot(ByRef dimentions As %String, ByRef measure As %String, cube As %String, pivotname As %String = "try9") As %Status
{
    set status=$$$OK
    try {
        //同じピボット名が存在してるかチェックし、存在してれば削除
        do ..deleteSameNamePivot(pivotname)
        set p=##class(%DeepSee.Dashboard.Pivot).%New()
        set p.createdBy="SuperUser"
        set p.name=pivotname
        set p.cubeName=cube
        //ディメンジョン設定
        set leveltype=""
        for {
            set leveltype=$ORDER(dimentions(leveltype))
            if leveltype="" quit
            do ..SetLevel(leveltype,.dimentions,.p)
        }
        //メジャー設定
        set mmdx=""
        for {
            set mmdx=$ORDER(measure(mmdx),1,data)
            if mmdx="" quit
            set m=##class(%DeepSee.Dashboard.PivotLevel).%New()
            set m.text=data
            set m.spec=mmdx
            do p.measures.Insert(m)
            kill data
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

ClassMethod SetLevel(leveltype As %String, ByRef dimentions As %String, ByRef pivot As %DeepSee.Dashboard.Pivot)
{
    set r1=""
    for {
        set r1=$ORDER(dimentions(leveltype,r1),1,data1)
        if r1="" quit
        // %DeepSee.Dashboard.PivotLevelのインスタンス生成
        set level1=##class(%DeepSee.Dashboard.PivotLevel).%New()
        set level1.spec=r1
        set level1.text=data1
        //子レベルあるかどうか （とりあえず２レベルまでにしておく）
        set r2=""
        for {
            set r2=$ORDER(dimentions(leveltype,r1,r2),1,data2)
            if r2="" quit
            set level2=##class(%DeepSee.Dashboard.PivotLevel).%New()
            set level2.spec=r2
            set level2.text=data2
            do level1.childLevels.Insert(level2)
            kill data2
        }
        //pivotに設定
        if leveltype="row" {
            do pivot.rowLevels.Insert(level1)
        }
        else {
            do pivot.columnLevels.Insert(level1)
        }
        kill data1
    }
}

ClassMethod testPivot(name As %String = "t1")
{
    set d("row","[NightShiftFlag].[H1].[NightShiftFlag].Members")="NightShiftFlag"
    set d("row","[NightShiftFlag].[H1].[NightShiftFlag].Members","[Department].[H1].[Department].Members")="Department"
    set d("col","[EmpRole].[H1].[EmpRole].Members")="EmpRole"
    set m("[Measures].[%COUNT]")="Count"
    set cube="ABiCAttendanceCube"
    set pivotname=name
    set st=..createPivot(.d,.m,cube,pivotname)
    if $$$ISERR(st) {
        write $system.Status.GetErrorText(st),!
    }
}

ClassMethod Test1(a As %String) As %String [ SqlName = Test1, SqlProc ]
{
    set ^iijima("d")={}.%FromJSON(a)
    set ^iijima("m")=a
    return "おっけー"
}

/// in: 自然言語入力から取り出したコンセプトのJSON文字列（配列）
/// 戻り値：結果の入ったダイナミックオブジェクト
/// {"url":"ダッシュボードのURL","recommend":"レコメンド文字列"}
/// 
/// セット例
/// set moji="[""number"", ""patients"", ""average age"", ""department"", ""examination"", ""gender""]"
/// set moji="[""number"", ""incident reports"", ""fault level"", ""continuity"", ""number"", ""incident reports"", ""april"", ""2024""]"
/// set moji="[""number"",""employees"", ""role"", ""working nights"", ""days"", ""april"", ""2024""]"
/// 戻り：文字を返す（エラーでも文字）
ClassMethod GetAnswer(in As %String(MAXLEN="")) As %String
{
    set status=$$$OK
    set returnjson=""
    try {
        set start=$ZH
        set inputarray={}.%FromJSON(in)
        //マルチリンガルモデル
        //set query = "SELECT TOP 1 VECTOR_COSINE(WordVec,(TO_VECTOR(EMBEDDING(?,'my-sentenceTransformer-config'),DOUBLE,384))) as sim,ID,Column,MDXColumn,TableName,CubeName,Expression from NLP.MetaInfo Order By sim desc"
        //軽量モデル
        set query = "SELECT TOP 1 VECTOR_COSINE(WordVec,EMBEDDING(?,'smallmodel-sentence-transformers-config')) as sim,ID,Column,MDXColumn,TableName,CubeName,Expression from NLP.MetaInfo Order By sim desc"
        set stmt=##class(%SQL.Statement).%New()
        $$$ThrowOnError(stmt.%Prepare(query))
        set iter=inputarray.%GetIterator()
        // cube("名")=カウント
        // dim("式")=""
        // measure("式")=""
        while iter.%GetNext(.key,.val) { 
            //w val,!
            if val="number" { continue }
            // もしYYYY（数値だけ）がきたらフィルターとする
            set rset=stmt.%Execute(val)
            // TOP 1なので
            do rset.%Next()
            if rset.CubeName'="" {
                // フィルタに使うものはキューブ名がない
                set cube(rset.CubeName)=$Get(cube(rset.CubeName))+1
            }
            set expression=rset.Expression
            if expression'="" {
                set mflg=$PIECE(expression,".",$LENGTH(expression,"."))
                if mflg'="Members" {
                    if $EXTRACT(expression)="&" {
                        // YearFilter 例　&[2024] 全部で7文字
                        set:$LENGTH(expression)=7 yearfilt=expression
                        // MonthFilter 例 &[11] 全部で5文字以下
                        set:$LENGTH(expression)<7 monthfilt=expression
                    }
                    else {
                        set measure(expression)=rset.MDXColumn
                    }
                }
                else {
                    set dim(expression)=rset.MDXColumn
                }
            }
        }

        //************
        //set end=$ZH
        //write "Vector Serarch実行時間：",end-start,!
        //************

        // CubeNameの多数決
        set n="",topcount=0,topcube=""
        for {
            set n=$ORDER(cube(n),1,count)
            if n="" quit
            if topcount<count {
                set topcount=count
                set topcube=n
            }
            kill count
        }

        // pivot作成
        /*
            変数dにd("row",式)="MDX表示名"
            変数mにm(メジャーの式)="MDX表示名"
        */
        set dcn="",prev="",cn=1
        for {
            set dcn=$order(dim(dcn),1,dname)
            if dcn="" quit
            if cn=1 {
                set d("row",dcn)=dname
            }
            if cn=2 {
                set d("row",prev,dcn)=dname
            }
            if cn=3 {
                set d("col",dcn)=dname
            }
            if cn=4 {
                set d("col",prev,dcn)=dname
            }
            set prev=dcn
            set cn=cn+1
            // dnameにConsecutiveDayがでてきたらABiCConsecutiveDayCubeを使うこと
            if dname="ConsecutiveDay" {
                set topcube="ABiCConsecutiveDayCube"
            }
        }

        //pivot作成
        set num=$increment(^ABiC("pivotNum"))
        set pivotname="ABiCPivot"_num
        set ^ABiC("pivotName",num)=pivotname_"^"_topcube
        $$$ThrowOnError(##class(NLP.Utils).createPivot(.d,.measure,topcube,pivotname))
        
        //Dashboard作成
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
        set p(pivotname)=topcube
        
        if $get(^ABiC("pivotNum"))=2 {
            // KPI追加する
            set p("kpipivot")="SQLBaseKPI.kpi"
            /*
            set num=$increment(^ABiC("pivotNum"))
            set ^ABiC("pivotName",num)="SQLBaseKPI.kpi"
            */
        }

        //************
        //zw p,dim,measure,d,monthfilt
        //************

        $$$ThrowOnError(##class(NLP.Utils).createDashboard(.p,dashname,1,1,$get(yearfilt),$get(monthfilt),1))

        //************
        //set end=$ZH
        //write "実行時間：",end-start,!
        //************
        set url=..#baseurl_dashname_".dashboard"
        set j={}
        set j.url=url
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
        //return j.%ToJSON()
   }
    catch ex {
        set status=ex.AsStatus()
        set url=$SYSTEM.Status.GetErrorText(status)
    }
    return returnjson
}

/// これ消えない
ClassMethod ABiCDelete()
{
    write "作成したダッシュボードとピボットを消します",!
    set cn=""
    for {
        set cn=$ORDER(^ABiC("dashName",cn),1,data)
        if cn="" quit
        set fullname=data_".dashboard.DFI"
        set status=##class(%DeepSee.Dashboard.Utils).%DeleteDashboard(fullname)
        if status=0 {
            write "消せなかった様子",!
            quit
        }
        kill data
    }
    set cn=""
    for {
        set cn=$ORDER(^ABiC("pivotName",cn),1,data)
        if cn="" quit
        set fullname=data_".pivot.DFI"
        set st=##class(NLP.Utils).deleteSameNamePivot(fullname)
        if $$$ISERR(st) {
            write $system.Status.GetErrorText(st),!
            quit
        }
        kill data
    }
    //kill ^ABiC
}

/// 計量モデル用テスト
ClassMethod GetAnswerTest(in As %String(MAXLEN="")) As %String
{
    set status=$$$OK
    set returnjson=""
    try {
        set start=$ZH
        set inputarray={}.%FromJSON(in)
        set query = "SELECT TOP 1 VECTOR_COSINE(WordVec,EMBEDDING(?,'smallmodel-sentence-transformers-config')) as sim,ID,Column,MDXColumn,TableName,CubeName,Expression from NLP.MetaInfo2 Order By sim desc"
        set stmt=##class(%SQL.Statement).%New()
        $$$ThrowOnError(stmt.%Prepare(query))
        set iter=inputarray.%GetIterator()
        // cube("名")=カウント
        // dim("式")=""
        // measure("式")=""
        while iter.%GetNext(.key,.val) { 
            //w val,!
            if val="number" { continue }
            // もしYYYY（数値だけ）がきたらフィルターとする
            set rset=stmt.%Execute(val)
            // TOP 1なので
            do rset.%Next()
            if rset.CubeName'="" {
                // フィルタに使うものはキューブ名がない
                set cube(rset.CubeName)=$Get(cube(rset.CubeName))+1
            }
            set expression=rset.Expression
            if expression'="" {
                set mflg=$PIECE(expression,".",$LENGTH(expression,"."))
                if mflg'="Members" {
                    if $EXTRACT(expression)="&" {
                        // YearFilter 例　&[2024] 全部で7文字
                        set:$LENGTH(expression)=7 yearfilt=expression
                        // MonthFilter 例 &[11] 全部で5文字以下
                        set:$LENGTH(expression)<7 monthfilt=expression
                    }
                    else {
                        set measure(expression)=rset.MDXColumn
                    }
                }
                else {
                    set dim(expression)=rset.MDXColumn
                }
            }
        }

        //************
        set end=$ZH
        write "Vector Serarch実行時間：",end-start,!
        //************
    }
    catch ex {
        set status=ex.AsStatus()
        set url=$SYSTEM.Status.GetErrorText(status)
    }
    return returnjson
}

}
