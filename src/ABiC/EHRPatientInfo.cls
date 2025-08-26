Class ABiC.EHRPatientInfo Extends %Persistent
{

Property PID As %Integer;

Property Name As %String;

Property Gender As %String;

Property Department As Hospital.Department;

Property Age As %Integer;

Property AdmissionDate As %Date;

Property DischargeDate As %Date;

Property Diagnosis As %String;

Property AdmissionFlg As %Boolean;

ClassMethod convertTBL()
{
    &sql(truncate table ABiC.EHRPatientInfo)
    //元データ入手
    set sql="select * from EHR.PatientInfo"
    set stmt=##class(%SQL.Statement).%New()
    set status=stmt.%Prepare(sql)
    set rset=stmt.%Execute()
    while rset.%Next() {
        set d(2)=rset.AdmissionDate
        set d(3)=rset.AdmissionFlg
        set d(4)=rset.Age
        set d(5)=##class(ABiC.Utils).GetDeptID(rset.Dept)
        set d(6)=rset.Diagnosis
        set d(7)=rset.DischargeDate
        set d(8)=rset.Gender
        set d(9)=rset.Name
        set d(10)=rset.PID
        &sql(insert into ABiC.EHRPatientInfo VALUES :d())
        if SQLCODE<0 {
            write %msg,!
        }
        kill d
    }
}

Storage Default
{
<Data name="EHRPatientInfoDefaultData">
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
<Value>Department</Value>
</Value>
<Value name="6">
<Value>Age</Value>
</Value>
<Value name="7">
<Value>AdmissionDate</Value>
</Value>
<Value name="8">
<Value>DischargeDate</Value>
</Value>
<Value name="9">
<Value>Diagnosis</Value>
</Value>
<Value name="10">
<Value>AdmissionFlg</Value>
</Value>
</Data>
<DataLocation>^ABiC.EHRPatientInfoD</DataLocation>
<DefaultData>EHRPatientInfoDefaultData</DefaultData>
<IdLocation>^ABiC.EHRPatientInfoD</IdLocation>
<IndexLocation>^ABiC.EHRPatientInfoI</IndexLocation>
<StreamLocation>^ABiC.EHRPatientInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
