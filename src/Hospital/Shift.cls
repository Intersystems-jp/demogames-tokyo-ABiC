Class Hospital.Shift Extends %Persistent
{

Property ShiftID As %Integer;

Property ShiftName As %String(VALUELIST = ",Day,Night,OnCall");

Property StartTime As %Time;

Property EndTime As %Time;

Storage Default
{
<Data name="ShiftDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ShiftID</Value>
</Value>
<Value name="3">
<Value>ShiftName</Value>
</Value>
<Value name="4">
<Value>StartTime</Value>
</Value>
<Value name="5">
<Value>EndTime</Value>
</Value>
</Data>
<DataLocation>^Hospital.ShiftD</DataLocation>
<DefaultData>ShiftDefaultData</DefaultData>
<IdLocation>^Hospital.ShiftD</IdLocation>
<IndexLocation>^Hospital.ShiftI</IndexLocation>
<StreamLocation>^Hospital.ShiftS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
