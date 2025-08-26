Class ABiC.DateDimention Extends %Persistent
{

Property DateOfEx As %Date;

Index DateOfExIdx On DateOfEx;

/// データ登録
ClassMethod createData() As %Status [ SqlName = createData, SqlProc ]
{
    set status=$$$OK
    Try {
        // 既存データ削除
        &sql(truncate table ABiC.DateDimention)

        // Hospital.Attendanceからデータ生成
        set stmt=##class(%SQL.Statement).%New()
        set sql="select distinct WorkDate From Hospital.Attendance"
        $$$ThrowOnError(stmt.%Prepare(sql))
        set rset=stmt.%Execute()
        while rset.%Next() {
            set o=..%New()
            set o.DateOfEx=rset.WorkDate
            $$$ThrowOnError(o.%Save())
        }
    }
    Catch ex {
        Set status=ex.AsStatus()
    }
    return status
}

Storage Default
{
<Data name="DateDimentionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateOfEx</Value>
</Value>
</Data>
<DataLocation>^ABiC.DateDimentionD</DataLocation>
<DefaultData>DateDimentionDefaultData</DefaultData>
<IdLocation>^ABiC.DateDimentionD</IdLocation>
<IndexLocation>^ABiC.DateDimentionI</IndexLocation>
<StreamLocation>^ABiC.DateDimentionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
