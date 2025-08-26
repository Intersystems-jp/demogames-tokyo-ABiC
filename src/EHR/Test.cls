Class EHR.Test Extends %Persistent
{

Property TestID As %Integer;

Property PID As EHR.PatientInfo;

Property TestDate As %Date;

Property TestName As %String;

Property TestResult As %String;

Storage Default
{
<Data name="TestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestID</Value>
</Value>
<Value name="3">
<Value>PID</Value>
</Value>
<Value name="4">
<Value>TestDate</Value>
</Value>
<Value name="5">
<Value>TestName</Value>
</Value>
<Value name="6">
<Value>TestResult</Value>
</Value>
</Data>
<DataLocation>^EHR.TestD</DataLocation>
<DefaultData>TestDefaultData</DefaultData>
<IdLocation>^EHR.TestD</IdLocation>
<IndexLocation>^EHR.TestI</IndexLocation>
<StreamLocation>^EHR.TestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
