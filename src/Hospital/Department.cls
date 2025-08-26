Class Hospital.Department Extends %Persistent
{

Property DeptID As %Integer;

Property DeptName As %String;

Index DeptNameIdx On DeptName [ Unique ];

Storage Default
{
<Data name="DepartmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeptID</Value>
</Value>
<Value name="3">
<Value>DeptName</Value>
</Value>
</Data>
<DataLocation>^Hospital.DepartmentD</DataLocation>
<DefaultData>DepartmentDefaultData</DefaultData>
<IdLocation>^Hospital.DepartmentD</IdLocation>
<IndexLocation>^Hospital.DepartmentI</IndexLocation>
<StreamLocation>^Hospital.DepartmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
