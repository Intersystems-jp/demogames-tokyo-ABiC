/// Hospital.Utilsを使って作成
Class ABiC.ConsecutiveAttendance Extends %Persistent
{

Property Attendance As Hospital.Attendance;

Property Department As Hospital.Department;

Property WorkHour As %Decimal;

Property OvertimeHour As %Decimal;

/// 開始日：StartDateだけど共有ディメンジョンのためにWorkDateで統一
Property WorkDate As DateDimention;

Property EndDate As %Date;

/// 連続勤務日数
Property ConsecutiveDay As %Integer;

Storage Default
{
<Data name="ConsecutiveAttendanceDefaultData">
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
<Value>WorkDate</Value>
</Value>
<Value name="7">
<Value>EndDate</Value>
</Value>
<Value name="8">
<Value>ConsecutiveDay</Value>
</Value>
</Data>
<DataLocation>^ABiC.ConsecutiveAttendanceD</DataLocation>
<DefaultData>ConsecutiveAttendanceDefaultData</DefaultData>
<IdLocation>^ABiC.ConsecutiveAttendanceD</IdLocation>
<IndexLocation>^ABiC.ConsecutiveAttendanceI</IndexLocation>
<StreamLocation>^ABiC.ConsecutiveAttendanceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
