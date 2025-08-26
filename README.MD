# DemoGames-Tokyo：ABiC

[*InterSystems Demo Games*](https://community.intersystems.com/node/584222)

東京 SE チーム提出のサンプルコードです。

このリポジトリには、IRIS に用意している REST API（WSGI）、InterSystems BI を利用した分析用キューブが含まれています。

分析元データは全て架空のもので、一部は外部テーブルを利用して取得する例も含めています（対象テーブル：[ABiC.IncidentReport](/src/ABiC/IncidentReport.cls)）。

***[English]***

This is sample code submitted by the Tokyo SE team.

This repository contains the REST API (WSGI) provided by IRIS and analysis cubes using InterSystems BI.

All source data for analysis is fictitious, and some examples include data obtained using foreign tables (target table: [ABiC.IncidentReport](/src/ABiC/IncidentReport.cls)).


## 分析対象（Analysis target）

病院内のシステムが持つあらゆるデータに対する分析を想定しています。

架空データを利用して以下分析キューブを用意しています。

***[English]***

We are considering analyzing all data held by the hospital's internal systems.

We have prepared the following analysis cubes using fictitious data.

- ABiCAttendanceCube

  病院に勤務する全ての人の勤務状況を分析できるキューブで、夜勤回数が多い人を部署別に集計できます。

  ***[English]***
  This cube allows you to analyze the work status of all hospital staff and compile statistics on the number of night shifts worked by each department.
  
  Source Table：[ABiC.Attendance](/src/ABiC/Attendance.cls)

- ABiCClinicDataCube

  患者の通院状況を診断名別、入院日数別で分析できます。

  ***[English]***
  You can analyze patient visits by diagnosis and length of stay.

  Source Table：[ABiC.EHRTest](/src/ABiC/EHRTest.cls)

- ABiCConsecutiveDayCube

  病院に勤務する全ての人の連続勤務日数による分析が行えます。

  ***[English]***
  You can analyze the consecutive number of days worked by all hospital staff.

  Source Table：[ABiC.ConsecutiveAttendance](/src/ABiC/ConsecutiveAttendance.cls)

- ABiCIncidentReportCube

  病院内のインシデントレポートを日付別、深刻度レベル別に分析できます。

  ***[English]***
  Incident reports within the hospital can be analyzed by date and severity level.

  Source Table：[ABiC.IncidentReport](/src/ABiC/IncidentReport.cls)

- MaterialTransaction

  病院内の資材在庫分析用
  
  ***[English]***
  For analyzing material inventory within hospitals

  Source Table：[Inventory.MaterialTransaction](/src/Inventory/MaterialTransaction.cls)  

## 使い方（How to use the ABiC）

### 事前準備（Preparation）

- OpenAI 用設定

  OpenAI を使用しています。事前に APIKey を入手し、以下のファイルの`key`変数に値を設定してください。

  [config.py](/src/wsgi/config.py)　15行目の二重引用符内に設定しファイルを保存してください。
  ```
  # APIkey
  key=""
  ```

- https 用設定

  https 用に自己証明ファイル（server.crtとserver.key）をご用意いただき、[webgateway以下](/webgateway/)に配置してください。

  http で試す場合は、[CSP.conf](/webgateway/CSP.conf)の **# SSL SECTION # の 23 行目以降をコメント化してからコンテナを開始してください。**


***[English]***

- For OpenAI setting
  We use OpenAI. Please obtain an APIKey in advance and set the value in the `key` variable in the following file.

  [config.py](/src/wsgi/config.py) Set the value within the double quotation marks on line 15 and save the file.

  ```
  # APIkey
  key=""
  ```
- For HTTPS settings

  Please prepare self-certification files (server.crt and server.key) for https and place them in [webgateway](/webgateway/).

  If you want to try http not https, **comment out line 23 and below in the # SSL SECTION # of [CSP.conf](/webgateway/CSP.conf) before starting the container.**

### 環境作成方法（How to create an environment）

コンテナ版 IRIS を利用しています。[config.py](#事前準備preparation) の `key` 変数の設定が完了してから以下実行してください。

***[English]***

We are using IRIS container images. Please complete the settings for the `key` variable in [config.py](#Preparation) before building the container.

- コンテナビルド＆開始（Container Build & Start）
  ```
  docker compose up -d
  ```

- コンテナ停止（Container stop）
  ```
  docker compose stop
  ```

- コンテナ破棄（Container down）
  ```
  docker compose down
  ```

### 実行方法（How to run）

https://localhost:7443/info/abic にアクセスし、「分析したい内容を入力してください」の下にあるテキストエリアに例文のような自然言語を入力し、ABiCアイコンをクリックします。

***[English]***

Go to https://localhost:7443/info/abic, enter natural language such as the example sentence in the text area under “Please enter the content you want to analyze.” and click the ABiC icon.

- Ex1

  2024年4月の障害レベル別、継続度別、インシデントレポート件数を教えて

  Tell me the number of incident reports by fault level, continuity and number of incident reports in April in 2024.

- Ex2

  2024年4月の従業員の役割別、夜勤、日勤数を教えて

  Tell me the number of employees, by role, working nights and days in April in 2024.

- Ex3

  2024年4月の従業員の役割別、夜勤、日勤、連続勤務日数を教えて。

  Tell me the number of employees, by role, working nights and days , ConsecutiveDay in April in 2024.

### REST API

ダッシュボード作成に、以下エンドポイントを利用します。

https://localhost:7443/info/mdx

エンドポイントは認証なしアクセスで実行できます。

POST 要求時、以下形式の JSON で、どのような分析を行いたいか自然言語で指定できます。

```
{
  "UserInput":"2024年4月の障害レベル別、継続度別、インシデントレポート件数を教えて"
}
```
応答には、作成されたダッシュボードのURLが返ります。

```
{
  "url": "https://localhost:7443/csp/user/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=ABiCDash1.dashboard"
}
```

REST API のコードは [WSGI の Flask アプリケーション](/src/wsgi/news.py)で実装しています。


---
***[English]***

The following endpoints are used to create dashboards.

https://localhost:7443/info/mdx

The endpoint can be executed with UnAuthentication access.

When making a POST request, you can specify what kind of analysis you want to perform in natural language using JSON in the following format.

```
{
  "UserInput":"Tell me the number of incident reports by fault level, continuity and number of incident reports in April in 2024."
}
```
The response will return the URL of the created dashboard.

```
{
  "url": "https://localhost:7443/csp/user/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=ABiCDash1.dashboard"
}
```
The REST API code is implemented in the [WSGI Flask application](/src/wsgi/news.py).

### ダッシュボード・ピボットの削除方法（How to delete the ABiC dashboards and pivots.）

IRIS にログインし、USER ネームスペースで以下 メソッドを実行します。

After logging into the USER namespace in the IRIS terminal, run the following method.

```
docker exec -it abiciris bash
iris session iris
write ##class(NLP.Utils2).ABiCDelete()
```

## おまけ（Bonus）

このデモでは、IRIS BI のキューブ定義を OpenAI にシステムプロンプトとして渡しています。

作成時、渡したいキューブ名をカンマ区切りで用意し、以下メソッドを実行するとダイナミックオブジェクトのインスタンスが作成されます。作成されたインスタンスを利用して、JSON文字列を出力し、情報を [config.py](/src/wsgi/config.py) の `mdxinfo 変数`に設定します。

この変数の値は、OpenAI 問い合わせ時のシステムプロンプトとして利用しています。

コンテナログイン後、IRISにログインします。
```
docker exec -it abiciris bash
iris session iris
```
以下の実行でキューブ定義のJSONを取得できます。
```
set cube="ABiCAttendanceCube,ABiCClinicDataCube,ABiCConsecutiveDayCube,ABiCIncidentReportCube,MaterialTransaction"
do ##class(NLP.Utils2).GetCubeInfo(cube,.outjson)
do outjson.%ToJSON()
```

---
***[English]***

In this demo, we pass the IRIS BI cube definition to OpenAI as a system prompt.

When creating, prepare the cube names you want to pass, separated by commas, and execute the following method to create a dynamic object instance. Use the created instance to output a JSON string and set the information in the `mdxinfo variable` of [config.py](/src/wsgi/config.py).

The value of this variable is used as the system prompt when querying OpenAI.

After logging into the container, log into IRIS.
```
docker exec -it abiciris bash
iris session iris
```

You can get the JSON for the cube definition by executing the following.
```
set cube="ABiCAttendanceCube,ABiCClinicDataCube,ABiCConsecutiveDayCube,ABiCIncidentReportCube,MaterialTransaction"
do ##class(NLP.Utils2).GetCubeInfo(cube,.outjson)
do outjson.%ToJSON()
```