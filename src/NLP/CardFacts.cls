Class NLP.CardFacts Extends JSONTemplate.Base
{

Property Key As %String;

Property Value As %String(MAXLEN = "");

XData Template [ MimeType = application/json ]
{
{
        "Key": "#(..Key)#:",
        "Value": "#(..Value)#"
}
}

}
