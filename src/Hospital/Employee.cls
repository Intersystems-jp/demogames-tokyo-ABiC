Class Hospital.Employee Extends %Persistent
{

/// EmployeeID
Property EmpID As %Integer;

Index EmpIDIdx On EmpID [ Unique ];

/// 従業員名
Property Name As %String;

/// 役職
Property EmpRole As %String(VALUELIST = ",Doctor,Nurse,Admin,Technician");

/// 所属部署
Property DeptID As Department;

/// 契約タイプ
Property EmpType As %String(VALUELIST = ",FullTime,PartTime,Contract");

Property Status As %String(VALUELIST = ",Active,Inactive");

Storage Default
{
<Data name="EmployeeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EmpID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>EmpRole</Value>
</Value>
<Value name="5">
<Value>DeptID</Value>
</Value>
<Value name="6">
<Value>EmpType</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^Hospital.EmployeeD</DataLocation>
<DefaultData>EmployeeDefaultData</DefaultData>
<IdLocation>^Hospital.EmployeeD</IdLocation>
<IndexLocation>^Hospital.EmployeeI</IndexLocation>
<StreamLocation>^Hospital.EmployeeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
