Class ABiC.Msg.RSSMessageBatch Extends %Persistent
{

Property Messages As list Of RSSMessage;

/// Description
Trigger DeleteRSSMessage [ Event = DELETE, Foreach = row/object ]
{
    new msgs,msgcn,msgid,st
    set msgs={Messages}
    for msgcn=1:1:$listlength(msgs) {
        set msgid=$LIST($list(msgs,msgcn),1)
        if ##class(ABiC.Msg.RSSMessage).%ExistsId(msgid) {
            set st=##class(ABiC.Msg.RSSMessage).%DeleteId(msgid)
            if $$$ISERR(st) {
                set %ok=0
                set SQLCODE=$system.Status.StatusToSQLCODE(st,.msg)
                set %msg=msg
            }
        }
    }
}

ClassMethod Test()
{
    set a1=##class(ABiC.Msg.RSSMessage).%New()
    set a1.Title="testtest"
    set a1.URL="http://localhost.com"
    set a1.PublishedDate="2024-12-12 01:22:33"
    set a2=##class(ABiC.Msg.RSSMessage).%New()
    set a2.Title="test2test2"
    set a2.URL="http://localhost2.com"
    set a2.PublishedDate="2024-10-12 11:12:33"   

    set msg=##class(ABiC.Msg.RSSMessageBatch).%New()
    do msg.Messages.Insert(a1)
    do msg.Messages.Insert(a2)
    w msg.%Save()
}

Storage Default
{
<Data name="RSSMessageBatchDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Messages</Value>
</Value>
</Data>
<DataLocation>^ABiC.Msg.RSSMessageBatchD</DataLocation>
<DefaultData>RSSMessageBatchDefaultData</DefaultData>
<IdLocation>^ABiC.Msg.RSSMessageBatchD</IdLocation>
<IndexLocation>^ABiC.Msg.RSSMessageBatchI</IndexLocation>
<StreamLocation>^ABiC.Msg.RSSMessageBatchS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
