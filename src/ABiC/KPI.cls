Class ABiC.KPI Extends %DeepSee.KPI
{

/// This callback, if implemented, lets a subclass provide an SQL statement to fetch data for this KPI. 
/// If there are filter values, they will be within the <var>%filterValues</var> property (an object).
Method %OnGetSQL(ByRef pSQL As %String) As %Status
{
	set pSQL="select ID,Product->ProductName As ProductName,Product->StockQuantity As Stock,"
    _"Quantity,TOCHAR(TransactionDate,'yyyy-mm-dd'),Count(TransactionDate) As NumOfTransaction"
    _" from Inventory.MaterialTransaction"
    _" Group by TransactionDate order by transactiondate desc"

    if $ISOBJECT(..%filterValues) {
        set tWhere=""
        if (..%filterValues.Year'="") {
            set tWhereYear="YEAR(TransactionDate)="_..%filterValues.Year
        }
        if (..%filterValues.Month'="") {
            set tWhereMonth="MONTH(TransactionDate)="_..%filterValues.Month
        }
        // Year 優先、Monthだけの時は指定しない
        if $get(tWhereYear)'="" {
            set tWhere=tWhereYear
        }
        if ($get(tWhere)'="")&&($Get(tWhereMonth)'="") {
            set tWhere=tWhere_" AND "_tWhereMonth
        }
        //今回のデモ用に2024年4月でフィルタする
        if ($get(tWhereYear)="")&&($get(tWhereMonth)="") {
            set tWhere="YEAR(TransactionDate)=2024 AND MONTH(TransactionDate)=4"
        }

        if (tWhere'="") {
            set tSQL1=$PIECE(pSQL,"Group by",1)
            set tSQL2=$PIECE(pSQL,"Group by",2)
            set pSQL=tSQL1_" WHERE "_tWhere
            set pSQL=pSQL_" Group by"_tSQL2
        }
    }

    quit $$$OK
}

/// This XData definition defines the KPI.
XData KPI [ XMLNamespace = "http://www.intersystems.com/kpi" ]
{
<kpi xmlns="http://www.intersystems.com/deepsee/kpi" name="SQLBaseKPI" sourceType="sql" caption="SQLKPI"
 sql="">
<property name="ID" displayName="ID" columnNo="1"/>
<property name="ProductName" displayName="ProductName" columnNo="2"/>
<property name="Stock" displayName="Stock" columnNo="3"/>
<property name="Quantity" displayName="Quantity" columnNo="4"/>
<property name="TransactionDate" displayName="TransactionDate" columnNo="5"/>
<property name="NumOfTransaction" displayName="NumOfTransaction" columnNo="6"/>
<filter valueList="2022,2023,2024,2025" name="Year" displayName="Year" filterProperty="" />
<filter valueList="1,2,3,4,5,6,7,8,9,10,11,12" name="Month" displayName="Month" filterProperty="" />
<action name="ShowAreaInfo" displayName="ShowAreaInfo"/>

</kpi>
}

ClassMethod %OnDashboardAction(pAction As %String, pContext As %ZEN.proxyObject, pDataSourceName As %String = "") As %Status
{
	if pAction="ShowAreaInfo" {
        Set after = pContext.currValue
        // Googleにニュース取りに行く
        set webserver=$piece(##class(NLP.Utils).#baseurl,"/csp",1)
        set command="newWindow:"_webserver_"/info/news/"_after
        Set pContext.command=command
    }
    return $$$OK
}

ClassMethod RSSParse(after As %String, before As %String) As ABiC.Msg.RSSMessageBatch [ Language = python ]
{
import iris
import feedparser
import json
from datetime import datetime, timedelta, timezone
tz = timezone(timedelta(hours=+9), 'Asia/Tokyo')

url="https://news.google.com/rss/search?q=国分寺+after:"+after+"+before:"+before+"&hl=ja&gl=JP&ceid=JP:ja"

#print(url);
rssfeed=feedparser.parse(url)
#サービスに送るメッセージクラスのインスタンス生成
batch=iris.cls("ABiC.Msg.RSSMessageBatch")._New()
#entries 以下にRSSの<channel>情報がlistで取得できる。
#published_parsedを使ってYYYY-MM-DD HH:MM:SSの形式に変換しておく(JSTで)
for data in rssfeed["entries"]:
    pubparsedate=data["published_parsed"]
    pubparsedateLocal=datetime(*pubparsedate[:6],tzinfo=timezone.utc).astimezone(tz)
    dispdate=pubparsedateLocal.strftime('%Y-%m-%d %H:%M:%S')
    #バッチクラスに含めるメッセージクラスのインスタンス生成
    msg=iris.cls("ABiC.Msg.RSSMessage")._New()
    msg.Title=data["title"]
    msg.PublishedDate=dispdate
    msg.URL=data["link"]
    #バッチクラスに登録
    batch.Messages.Insert(msg)
return batch
#list->JSON文字に変換して返す
#return json.dumps(newdata,ensure_ascii=False)
}

}
