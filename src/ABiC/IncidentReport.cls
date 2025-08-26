Class ABiC.IncidentReport Extends %Persistent
{

Property ReportID As %Integer [ SqlColumnNumber = 2 ];

Property Department As Hospital.Department [ SqlColumnNumber = 3 ];

/// 従業員番号
Property Related As list Of Hospital.Employee [ SqlColumnNumber = 4 ];

Property WorkDate As ABiC.DateDimention [ SqlColumnNumber = 5 ];

Property ReportLevel As %String(VALUELIST = ",0,1,2,3a,3b,4a,4b,5") [ SqlColumnNumber = 6 ];

Property HarmScore As %String(VALUELIST = ",Mild,Moderate to Severe,Mild to Moderate,Moderate,Severe") [ SqlColumnNumber = 7 ];

Property DurationOfHarm As %String(VALUELIST = ",None,Transient,Permanent,Fatal") [ SqlColumnNumber = 8 ];

Property Report As %String(MAXLEN = "") [ SqlColumnNumber = 9 ];

Property ReportVec As %Vector(DATATYPE = "DOUBLE", LEN = 384) [ SqlColumnNumber = 10 ];

Property DateOfOccurence As %Date [ SqlColumnNumber = 11 ];

/// 詳細リストでこのストアドを呼ぶとリストコレクションは$LBとしてとれる
ClassMethod GetEmpInfo(in As %String) As %String [ SqlName = GetEmpInfo, SqlProc ]
{
    set empname=""
    if $get(in)="" return ""
    for i=1:1:$listlength(in) {
        set id=$list(in,i)
        set e=##class(Hospital.Employee).%OpenId(id)
        if empname="" {
            set empname=e.Name
        }
        else {
            set empname=empname_","_e.Name
        }
    }
    return empname
}

ClassMethod GetEmpRoleInfo(in As %String) As %String [ SqlName = GetEmpRoleInfo, SqlProc ]
{
    set emprole=""
    if $get(in)="" return ""
    for i=1:1:$listlength(in) {
        set id=$list(in,i)
        set e=##class(Hospital.Employee).%OpenId(id)
        if emprole="" {
            set emprole=e.EmpRole
        }
        else {
            set emprole=emprole_","_e.EmpRole
        }
    }
    return emprole
}

ClassMethod convertTBL()
{
    &sql(truncate table ABiC.IncidentReport)
    //ForeingnTableでデータ取って新しいテーブルに格納する
    set sql="select * from ABiC.FTIncidentReport"
    set stmt=##class(%SQL.Statement).%New()
    //set stmt.%SelectMode=1
    set status=stmt.%Prepare(sql)
    set rset=stmt.%Execute()
    while rset.%Next() {
        kill empidlb,d
        set empid=rset.Related
        for i=1:1:$Length(empid,",") {
            set $LIST(empidlb,i)=$piece(empid,",",i)
        }
        set d(2)=rset.ReportID
        set d(3)=##class(ABiC.Utils).GetDeptID(rset.Department)
        set d(4)=empidlb
        set d(5)=##class(ABiC.Utils).GetDateID($ZDATE(rset.DateOfOccurence,3))
        if d(5)="" {
            continue
        }
        set d(6)=rset.ReportLevel
        set d(7)=rset.HarmScore
        set d(8)=rset.DurationOfHarm
        set d(9)=rset.Report
        set d(11)=rset.DateOfOccurence
        &sql(insert into ABiC.IncidentReport VALUES :d())
        if SQLCODE<0 {
            write %msg,!
        }
    }
}

Storage Default
{
<Data name="IncidentReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReportID</Value>
</Value>
<Value name="3">
<Value>Department</Value>
</Value>
<Value name="4">
<Value>Related</Value>
</Value>
<Value name="5">
<Value>WorkDate</Value>
</Value>
<Value name="6">
<Value>ReportLevel</Value>
</Value>
<Value name="7">
<Value>HarmScore</Value>
</Value>
<Value name="8">
<Value>DurationOfHarm</Value>
</Value>
<Value name="9">
<Value>Report</Value>
</Value>
<Value name="10">
<Value>ReportVec</Value>
</Value>
<Value name="11">
<Value>DateOfOccurence</Value>
</Value>
</Data>
<DataLocation>^ABiC.IncidentReportD</DataLocation>
<DefaultData>IncidentReportDefaultData</DefaultData>
<IdLocation>^ABiC.IncidentReportD</IdLocation>
<IndexLocation>^ABiC.IncidentReportI</IndexLocation>
<StreamLocation>^ABiC.IncidentReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
