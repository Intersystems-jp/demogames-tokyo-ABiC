Class EHR.PatientInfo Extends %Persistent
{

Property PID As %Integer;

Property Name As %String;

Property Gender As %String;

Property Dept As %String;

Property Age As %Integer;

Property AdmissionDate As %Date;

Property DischargeDate As %Date;

Property Diagnosis As %String;

Property AdmissionFlg As %Boolean;

Storage Default
{
<Data name="PatientInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Gender</Value>
</Value>
<Value name="5">
<Value>Dept</Value>
</Value>
<Value name="6">
<Value>AdmissionDate</Value>
</Value>
<Value name="7">
<Value>DischargeDate</Value>
</Value>
<Value name="8">
<Value>Diagnosis</Value>
</Value>
<Value name="9">
<Value>Age</Value>
</Value>
<Value name="10">
<Value>AdmissionFlg</Value>
</Value>
</Data>
<DataLocation>^EHR.PatientInfoD</DataLocation>
<DefaultData>PatientInfoDefaultData</DefaultData>
<IdLocation>^EHR.PatientInfoD</IdLocation>
<IndexLocation>^EHR.PatientInfoI</IndexLocation>
<StreamLocation>^EHR.PatientInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
