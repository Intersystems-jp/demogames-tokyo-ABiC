Class Hospital.Attendance Extends %Persistent
{

Property AttendanceID As %Integer;

Property EmpID As Employee;

Property WorkDate As %Date;

Property WorkHour As %Decimal;

Property OvertimeHour As %Decimal;

Property Shift As Shift;

Property NightShiftFlag As %Boolean;

Index WorkDateIdx On WorkDate;

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
<Value>WorkDate</Value>
</Value>
<Value name="5">
<Value>WorkHour</Value>
</Value>
<Value name="6">
<Value>OvertimeHour</Value>
</Value>
<Value name="7">
<Value>Shift</Value>
</Value>
<Value name="8">
<Value>NightShiftFlag</Value>
</Value>
</Data>
<DataLocation>^Hospital.AttendanceD</DataLocation>
<DefaultData>AttendanceDefaultData</DefaultData>
<IdLocation>^Hospital.AttendanceD</IdLocation>
<IndexLocation>^Hospital.AttendanceI</IndexLocation>
<StreamLocation>^Hospital.AttendanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
