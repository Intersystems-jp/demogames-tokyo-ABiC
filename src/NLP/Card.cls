Class NLP.Card Extends JSONTemplate.Base
{

Property createDate As %Date(FORMAT = 3);

Property Facts As list Of NLP.CardFacts;

Property URL As %String(MAXLEN = "");

XData Template [ MimeType = application/json ]
{
{
    "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
    "type": "AdaptiveCard",
    "version": "1.0",
    "body": [
        {
            "type": "ColumnSet",
            "columns": [
                {
                    "type": "Column",
                    "width": "auto",
                    "items": [
                      {
                        "type": "Image",
                        "url": "https://raw.githubusercontent.com/iijimam/images/refs/heads/main/abic.png",
                        "size": "small"
                      }
                    ]
                },
                {
                    "type": "Column",
                    "width": "auto",
                    "items": [
                        {
                            "type": "TextBlock",
                            "weight": "Bolder",
                            "text": "Notification from ABiC",
                            "wrap": true
                        },
                        {
                            "type": "TextBlock",
                            "spacing": "None",
                            "text": "Created : #(..createDate)#",
                            "isSubtle": true,
                            "wrap": true
                        }
                    ]
                }
            ]
        },
        {
            "type": "TextBlock",
            "text": "[The results of your analysis request are ready!](#(..URL)#)",
            "wrap": true
        },
        {
            "type": "FactSet",
            "facts": ["#(..Facts)#"]
        }
    ]
}
}

}
