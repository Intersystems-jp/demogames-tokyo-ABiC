Class ABiC.Attendance Extends %Persistent
{

Property AttendanceID As %Integer [ SqlColumnNumber = 2 ];

Property EmpID As Hospital.Employee [ SqlColumnNumber = 3 ];

Property Department As Hospital.Department [ SqlColumnNumber = 4 ];

Property WorkDate As ABiC.DateDimention [ SqlColumnNumber = 5 ];

Property WorkHour As %Decimal [ SqlColumnNumber = 6 ];

Property OvertimeHour As %Decimal [ SqlColumnNumber = 7 ];

Property Shift As Hospital.Shift [ SqlColumnNumber = 8 ];

Property NightShiftFlag As %Boolean [ SqlColumnNumber = 9 ];

Index WorkDateIdx On WorkDate;

ClassMethod convertTBL()
{
    &sql(truncate table ABiC.Attendance)
    //ForeingnTableでデータ取って新しいテーブルに格納する
    set sql="select * from Hospital.Attendance"
    set stmt=##class(%SQL.Statement).%New()
    set stmt.%SelectMode=1
    set status=stmt.%Prepare(sql)
    set rset=stmt.%Execute()
    while rset.%Next() {
        set d(2)=rset.AttendanceID
        set d(3)=rset.EmpID
        set d(4)=##class(ABiC.Utils).GetDeptFromEmpID(rset.EmpID)
        set d(5)=##class(ABiC.Utils).GetDateID(rset.WorkDate)
        set d(6)=rset.WorkHour
        set d(7)=rset.OvertimeHour
        set d(8)=rset.Shift
        set d(9)=rset.NightShiftFlag
        &sql(insert into ABiC.Attendance VALUES :d())
        if SQLCODE<0 {
            write %msg,!
        }
        kill d
    }
}

Storage Default
{
<Data name="AttendanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AttendanceID</Value>
</Value>
<Value name="3">
<Value>EmpID</Value>
</Value>
<Value name="4">
<Value>Department</Value>
</Value>
<Value name="5">
<Value>WorkDate</Value>
</Value>
<Value name="6">
<Value>WorkHour</Value>
</Value>
<Value name="7">
<Value>OvertimeHour</Value>
</Value>
<Value name="8">
<Value>Shift</Value>
</Value>
<Value name="9">
<Value>NightShiftFlag</Value>
</Value>
</Data>
<DataLocation>^ABiC.AttendanceD</DataLocation>
<DefaultData>AttendanceDefaultData</DefaultData>
<IdLocation>^ABiC.AttendanceD</IdLocation>
<IndexLocation>^ABiC.AttendanceI</IndexLocation>
<StreamLocation>^ABiC.AttendanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
