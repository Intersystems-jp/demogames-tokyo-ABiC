Class ABiC.EHRTest Extends %Persistent
{

Property TestID As %Integer;

Property PID As ABiC.EHRPatientInfo;

Property WorkDate As ABiC.DateDimention;

Property TestName As %String;

Property TestResult As %String;

Index WorkDateIdx On WorkDate;

ClassMethod convertTBL()
{
    &sql(truncate table ABiC.EHRTest)
    //元データ入手
    set sql="select * from EHR.Test"
    set stmt=##class(%SQL.Statement).%New()
    set status=stmt.%Prepare(sql)
    set stmt.%SelectMode=1
    set rset=stmt.%Execute()
    while rset.%Next() {
        set d(2)=rset.PID
        set d(3)=rset.TestID
        set d(4)=rset.TestName
        set d(5)=rset.TestResult
        //DateDimentionにない日付がきたらとりあえずある日付に置き換える
        set dateid=##class(ABiC.Utils).GetDateID(rset.TestDate)
        if dateid="" {
            set dateid=$random($get(^ABiC.DateDimentionD))+1
        }
        set d(6)=dateid
        &sql(insert into ABiC.EHRTest VALUES :d())
        if SQLCODE<0 {
            write %msg,!
        }
        kill d
    }
}

Storage Default
{
<Data name="EHRTestDefaultData">
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
<Value>WorkDate</Value>
</Value>
<Value name="5">
<Value>TestName</Value>
</Value>
<Value name="6">
<Value>TestResult</Value>
</Value>
</Data>
<DataLocation>^ABiC.EHRTestD</DataLocation>
<DefaultData>EHRTestDefaultData</DefaultData>
<IdLocation>^ABiC.EHRTestD</IdLocation>
<IndexLocation>^ABiC.EHRTestI</IndexLocation>
<StreamLocation>^ABiC.EHRTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
