Class Hospital.OvertimeRequest Extends %Persistent
{

Property OvertimeID As %Integer;

Property EmpID As Employee;

Property WorkDate As %Date;

Property OvertimeHour As %Decimal;

Storage Default
{
<Data name="OvertimeRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OvertimeID</Value>
</Value>
<Value name="3">
<Value>EmpID</Value>
</Value>
<Value name="4">
<Value>WorkDate</Value>
</Value>
<Value name="5">
<Value>OvertimeHour</Value>
</Value>
</Data>
<DataLocation>^Hospital.OvertimeRequestD</DataLocation>
<DefaultData>OvertimeRequestDefaultData</DefaultData>
<IdLocation>^Hospital.OvertimeRequestD</IdLocation>
<IndexLocation>^Hospital.OvertimeRequestI</IndexLocation>
<StreamLocation>^Hospital.OvertimeRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
