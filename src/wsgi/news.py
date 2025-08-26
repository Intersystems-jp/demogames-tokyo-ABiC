from flask import Flask, render_template,request
import iris
import requests
import json
from datetime import datetime, timedelta, timezone
import config

app = Flask(__name__)

def rss(after):
    import feedparser
    tz = timezone(timedelta(hours=+9), 'Asia/Tokyo')

    afterdt=datetime.strptime(after,"%Y-%m-%d")
    beforedt=afterdt+timedelta(days=2)
    before=beforedt.strftime("%Y-%m-%d")

    url="https://news.google.com/rss/search?q=国分寺+after:"+after+"+before:"+before+"&hl=ja&gl=JP&ceid=JP:ja"

    #print(url);
    rssfeed=feedparser.parse(url)
    #print(rssfeed)
    for data in rssfeed["entries"]:
        pubparsedate=data["published_parsed"]
        pubparsedateLocal=datetime(*pubparsedate[:6],tzinfo=timezone.utc).astimezone(tz)
        dispdate=pubparsedateLocal.strftime('%Y-%m-%d %H:%M:%S')
        print("<br>")
        print(dispdate)
        link="<a href='"+data["links"][0].href+"' target='_blank'>"+data["title"]+"</a>"
        print(link)
    return rssfeed


@app.route('/', methods=['GET'])
def meetup():
    name = "Hello ABiC!"
    return name

@app.route('/news/<date>')
def getinfo(date):
    contents = f"指定された日付👉{date} ＋２日間の情報を探します"
    print(contents)
    rssret=rss(date)
    return "ok"

@app.route("/ABiC",methods=['POST'])
def getAnswer():
    param=request.data
    #moji=iris.cls("NLP.Utils").Test1(param)
    info=iris.cls("NLP.Utils").GetAnswer(param)
    return info

@app.route("/white")
def white():
    return render_template("white.html")

@app.route('/abic')
def index():
    left_content = "これは左側のコンテンツです。"
    right_content = "これは右側のコンテンツです。"
    return render_template('abic.html', left_content=left_content, right_content=right_content)


#どのキューブ、ディメンジョン、メジャーを使うと良いかをOpenAIから入手
@app.route('/mdx',methods=['POST'])
def mdx2():
    body = request.get_json()

    APIKey=config.key

    API_SERVER_URL="https://api.openai.com/v1/chat/completions"
    headers={
        "Content-Type":"application/json;charset=utf-8",
        "Authorization": f"Bearer {APIKey}",
    }
    data = {
        "model": "gpt-4o",
        "messages": [
            {
                "role": "system",
                "content": f"{config.system_prompt}"
            },
            {
                "role": "system",
                "content": f"定義されたキューブ情報です。{config.mdxinfo}",
            },
            {
                "role":"system",
                "content":f"表記例のJSONです。{config.example}"
            },
            {
                "role":"system",
                "content": f"{body["UserInput"]}"
            }
        ]
    }
    response = requests.post(API_SERVER_URL, headers=headers, json=data)
    result = response.json()
    inputjson=result["choices"][0]["message"]["content"]
    #一重引用符で戻ることがあるので変換を一応かける
    inputjson=inputjson.replace("\'", "\"")
    # ダッシュボード作成
    answer=iris.cls("NLP.Utils2").Run(inputjson,APIKey)
    return answer 

if __name__ == "__main__":
    app.run(debug=True)