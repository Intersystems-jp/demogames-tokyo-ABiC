Class BI.Attendance Extends %Persistent
{

Property Attendance As Hospital.Attendance;

Property Department As Hospital.Department;

Property WorkHour As %Decimal;

Property OvertimeHour As %Decimal;

Property StartDate As %Date;

Property EndDate As %Date;

/// 連続勤務日数
Property ConsecutiveDay As %Integer;

Storage Default
{
<Data name="AttendanceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Attendance</Value>
</Value>
<Value name="3">
<Value>Department</Value>
</Value>
<Value name="4">
<Value>WorkHour</Value>
</Value>
<Value name="5">
<Value>OvertimeHour</Value>
</Value>
<Value name="6">
<Value>StartDate</Value>
</Value>
<Value name="7">
<Value>EndDate</Value>
</Value>
<Value name="8">
<Value>ConsecutiveDay</Value>
</Value>
</Data>
<DataLocation>^BI.AttendanceD</DataLocation>
<DefaultData>AttendanceDefaultData</DefaultData>
<IdLocation>^BI.AttendanceD</IdLocation>
<IndexLocation>^BI.AttendanceI</IndexLocation>
<StreamLocation>^BI.AttendanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
