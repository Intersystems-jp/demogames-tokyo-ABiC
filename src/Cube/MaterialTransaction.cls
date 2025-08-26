/// 
Class Cube.MaterialTransaction Extends %DeepSee.CubeDefinition [ DependsOn = Inventory.MaterialTransaction, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="MaterialTransaction" displayName="MaterialTransaction" disabled="false" abstract="false" sourceClass="Inventory.MaterialTransaction" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="ProductName" disabled="false" hasAll="false" allCaption="All ProductName" allDisplayName="ProductName" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ProductName" disabled="false" sourceProperty="Product.ProductName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="TransactionDate" disabled="false" hasAll="false" allCaption="All TransactionDate" allDisplayName="TransactionDate" sourceProperty="TransactionDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="TransactionDateYear" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
      <level name="TransactionDateMonth" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
      <level name="TransactionDateDay" disabled="false" timeFunction="DayNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="5">
      </level>
    </hierarchy>
  </dimension>
  <measure name="Quantity" disabled="false" sourceProperty="Quantity" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="1">
  </measure>
  <listing name="getInventory" disabled="false" listingType="table" fieldList="Product-&gt;Price,Product-&gt;Description,Product-&gt;ProductName,Product-&gt;StockQuantity,TransactionDate">
  </listing>
</cube>
}

Parameter DOMAIN;

}
