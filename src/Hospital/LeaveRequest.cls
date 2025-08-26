Class Hospital.LeaveRequest Extends %Persistent
{

Property LeaveID As %Integer;

Property EmpID As Employee;

Property LeaveType As %String(VALUELIST = ",PaidLeave,SickLeave,MaternityLeave");

Property StartDate As %Date;

Storage Default
{
<Data name="LeaveRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LeaveID</Value>
</Value>
<Value name="3">
<Value>EmpID</Value>
</Value>
<Value name="4">
<Value>LeaveType</Value>
</Value>
<Value name="5">
<Value>StartDate</Value>
</Value>
</Data>
<DataLocation>^Hospital.LeaveRequestD</DataLocation>
<DefaultData>LeaveRequestDefaultData</DefaultData>
<IdLocation>^Hospital.LeaveRequestD</IdLocation>
<IndexLocation>^Hospital.LeaveRequestI</IndexLocation>
<StreamLocation>^Hospital.LeaveRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
