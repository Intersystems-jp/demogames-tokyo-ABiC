Class Hospital.WorkHistory Extends %Persistent
{

Property HistoryID As %Integer;

Property EmpID As Employee;

Property NewDeptID As Department;

Property OldDeptID As Department;

Property TransferDate As %Date;

Storage Default
{
<Data name="WorkHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HistoryID</Value>
</Value>
<Value name="3">
<Value>EmpID</Value>
</Value>
<Value name="4">
<Value>NewDeptID</Value>
</Value>
<Value name="5">
<Value>OldDeptID</Value>
</Value>
<Value name="6">
<Value>TransferDate</Value>
</Value>
</Data>
<DataLocation>^Hospital.WorkHistoryD</DataLocation>
<DefaultData>WorkHistoryDefaultData</DefaultData>
<IdLocation>^Hospital.WorkHistoryD</IdLocation>
<IndexLocation>^Hospital.WorkHistoryI</IndexLocation>
<StreamLocation>^Hospital.WorkHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
