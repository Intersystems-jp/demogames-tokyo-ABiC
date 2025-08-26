Class Inventory.Product Extends %Persistent
{

Property ProductID As %Integer;

Property ProductName As %String(MAXLEN = 100);

Property Description As %String(MAXLEN = "");

Property StockQuantity As %Integer;

Property Price As %Decimal;

/// 在庫を減らす
ClassMethod Reduce(id As %Integer, in As %Integer) [ SqlProc ]
{
    if ..%ExistsId(id)=0 return
    set o=..%OpenId(id)
    if o.StockQuantity<in return
    set o.StockQuantity=o.StockQuantity-in
    set st=o.%Save()
}

ClassMethod create() [ SqlProc ]
{
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(1,'Syringe','Syringe 1 box (100 pcs.)',100,15))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(2,'Needle','Injection needle / Suture needle 1 box (100 pcs.)',100,15))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(3,'IV set','Intravenous set 1 box (50 set.)',30,100))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(4,'Infusion bag','IV fluid bag',100,3))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(5,'Gauze','Gauze 1 box (200 sheets)',50,10))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(6,'Bandage','Bandage 1 box (12 rolls)',30,15))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(7,'Adhesive bandage','Band-Aid 1 box (100 sheets)',20,10))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(8,'Medical mask / N95 mask','N95 mask 1 box (50 sheets)',30,2598))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(9,'Medical gloves / Surgical gloves','Surgical gloves 1 box (100 sheets)',20,20))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(10,'Disinfectant','Alcohol / Iodine-based antiseptic 1 bottle (500ml)',100,8))

    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(11,'Catheter','Urinary catheter / Central venous catheter, CVC 1 piece',80,15))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(12,'Drain','Chest drain / Abdominal drain 1',50,25))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(13,'Suction device','Suction tube / Cannula 1 set',30,20))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(14,'Oxygen mask','Oxygen mask 1 piece',100,5))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(15,'Blood pressure monitor','Blood pressure monitor (With cuff) 1 unit',5,50))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(16,'Thermometer','Thermometer 1 unit',5,15))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(17,'Scalpel (Surgical knife)','Scalpel (Surgical knife) 1 box (10 pcs.)',10,25))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(18,'Suture thread','Absorbable / Non-absorbable 1 box (12 pcs.)',10,30))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(19,'Surgical drape','Surgical drape 1 piece',20,5))
    &sql(insert into Inventory.Product (ProductID,ProductName,Description,StockQuantity,Price)
     VALUES(20,'Electronic medical record terminal (Tablet / PC)','Electronic medical record terminal (Tablet / PC) 1 unit',0,2000))
}

Storage Default
{
<Data name="ProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProductID</Value>
</Value>
<Value name="3">
<Value>ProductName</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>StockQuantity</Value>
</Value>
<Value name="6">
<Value>Price</Value>
</Value>
</Data>
<DataLocation>^Inventory.ProductD</DataLocation>
<DefaultData>ProductDefaultData</DefaultData>
<IdLocation>^Inventory.ProductD</IdLocation>
<IndexLocation>^Inventory.ProductI</IndexLocation>
<StreamLocation>^Inventory.ProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
