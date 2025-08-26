Class Inventory.MaterialTransaction Extends %Persistent
{

Property TransactionID As %Integer;

Property Product As Inventory.Product;

Property TransactionDate As %Date;

Property Quantity As %Integer;

Storage Default
{
<Data name="MaterialTransactionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransactionID</Value>
</Value>
<Value name="3">
<Value>Product</Value>
</Value>
<Value name="4">
<Value>TransactionDate</Value>
</Value>
<Value name="5">
<Value>Quantity</Value>
</Value>
</Data>
<DataLocation>^Inventory.MaterialTransactionD</DataLocation>
<DefaultData>MaterialTransactionDefaultData</DefaultData>
<IdLocation>^Inventory.MaterialTransactionD</IdLocation>
<IndexLocation>^Inventory.MaterialTransactionI</IndexLocation>
<StreamLocation>^Inventory.MaterialTransactionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
