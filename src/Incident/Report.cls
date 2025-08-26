Class Incident.Report Extends %Persistent
{

Property ReportID As %Integer;

Property Department As %String;

/// 従業員番号
Property Related As list Of %Integer;

Property DateOfOccurence As %Date;

Property ReportLevel As %String(VALUELIST = ",0,1,2,3a,3b,4a,4b,5");

Property HarmScore As %String(VALUELIST = ",Mild,Moderate to Severe,Mild to Moderate,Moderate,Severe");

Property DurationOfHarm As %String(VALUELIST = ",None,Transient,Permanent,Fatal");

Property Report As %String(MAXLEN = "");

Property ReportVec As %Vector(DATATYPE = "DOUBLE", LEN = 384);

/// 詳細リストでこのストアドを呼ぶとリストコレクションは$LBとしてとれる
ClassMethod GetEmployee(in As %String) As %String [ SqlName = GetEmployee, SqlProc ]
{
    set empname=""
    if $get(in)="" return ""
    for i=1:1:$listlength(in) {
        set id=$list(in,i)
        set e=##class(Hospital.Employee).%OpenId(id)
        if empname="" {
            set empname=e.Name
        }
        else {
            set empname=empname_","_e.Name
        }
    }
    return empname
}

ClassMethod setVector()
{
    /*
    sentence_transformer　をpip installで入れてから

INSERT INTO %Embedding.Config (Name, Configuration, EmbeddingClass, VectorLength, Description)
  VALUES ('my-sentenceTransformer-config', 
          '{"modelName": "sentence-transformers/stsb-xlm-r-multilingual",
          "hfCachePath": "/home/irisowner/.cache/huggingface/hub/models--sentence-transformers--stsb-xlm-r-multilingual"}',
          '%Embedding.SentenceTransformers', 
          384,  
          'a multi language model provided by SentenceTransformers')     
    
    Embedding関数の構成作る
    https://usjira.iscinternal.com/browse/DP-438186
    エラー出て動かないのであとでやる

    */
}

Storage Default
{
<Data name="ReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReportID</Value>
</Value>
<Value name="3">
<Value>Department</Value>
</Value>
<Value name="4">
<Value>Related</Value>
</Value>
<Value name="5">
<Value>DateOfOccurence</Value>
</Value>
<Value name="6">
<Value>ReportLevel</Value>
</Value>
<Value name="7">
<Value>HarmScore</Value>
</Value>
<Value name="8">
<Value>DurationOfHarm</Value>
</Value>
<Value name="9">
<Value>Report</Value>
</Value>
<Value name="10">
<Value>ReportVec</Value>
</Value>
</Data>
<DataLocation>^Incident.ReportD</DataLocation>
<DefaultData>ReportDefaultData</DefaultData>
<IdLocation>^Incident.ReportD</IdLocation>
<IndexLocation>^Incident.ReportI</IndexLocation>
<StreamLocation>^Incident.ReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
