/// メインシステムではない場所にあるデータをJDBC経由で外部テーブル接続＋データコネクタ使ってキューブ作成
/// インシデントレポートをとってくる
Class ABiC.IncidentReportConnect Extends %DeepSee.DataConnector
{

Parameter SUPPORTSIDLIST = 1;

Parameter SUPPORTSSINGLE = 1;

XData Output [ XMLNamespace = "http://www.intersystems.com/deepsee/connector/output" ]
{
<connector>
    <property name="%ID" sourceProperty="%ID" idKey="true" />
    <property name="DateOfOccurence" sourceProperty="DateOfOccurence" type="ABiC.DateDimention" />
    <property name="DeptName" sourceProperty="DeptName" type="Hospital.Department" />
    <property name="HarmScore" sourceProperty="HarmScore" type="%String" />
    <property name="ReportLevel" sourceProperty="ReportLevel" type="%String" />
    <property name="Related" sourceProperty="Related" type="%String" />
    <property name="DurationOfHarm" sourceProperty="DurationOfHarm" type="%String" />
    <property name="Report" sourceProperty="Report" type="%String" />
 </connector>
}

Method %OnGetSourceResultSet(ByRef pParameters, Output pResultSet) As %Status
{
	set status=$$$OK
    Try {

        set stmt=##class(%SQL.Statement).%New()
        set sql="select %ID,ABiC.GetDateID(DateOfOccurence) As DateOfOccurence,ABiC.GetDeptID(Department) As DeptName,HarmScore,ReportLevel,Related,DurationOfHarm,Report from ABiC.IncidentReport"
        set pResultSett=stmt.%ExecDirect(sql)
        if pResultSet.%SQLCODE<0 {
            throw ##class(%Exception.SQL).CreateFromSQLCODE(pResultSet.%SQLCODE,pResultSet.%Message)
        }
    }
    Catch ex {
        set status=ex.AsStatus()
    }
    return status
}

}
