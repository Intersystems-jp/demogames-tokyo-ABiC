Class NLP.Utils
{

/// ダッシュボードのベースURL
/// Parameter baseurl = "https://localhost:9443/csp/user/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=";
Parameter baseurl = "https://ec2-54-168-241-226.ap-northeast-1.compute.amazonaws.com/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=";

ClassMethod dropMetaInfo()
{
    &sql(drop table NLP.MetaInfo)
    &sql(delete from %Embedding.Config where Name='my-sentenceTransformer-config')
    &sql(delete from %Embedding.Config where Name='smallmodel-sentence-transformers-config')
}

ClassMethod createMetaInfo()
{
    &sql(
    INSERT INTO %Embedding.Config (Name, Configuration, EmbeddingClass, Description)
    VALUES ('smallmodel-sentence-transformers-config',
            '{"modelName": "sentence-transformers/all-MiniLM-L6-v2",
            "hfToken":"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",
            "hfCachePath": "/home/irisowner/.cache/huggingface/hub/models--sentence-transformers--all-MiniLM-L6-v2"}',
            '%Embedding.SentenceTransformers',
            'a small SentenceTransformers embedding model')
    )
    if SQLCODE<0 {
        write %msg,!
        return
    }
    &sql(
    CREATE TABLE NLP.MetaInfo (
        Word VARCHAR(1000),
        Column VARCHAR(50),
        MDXColumn VARCHAR(100),
        TableName VARCHAR(100),
        CubeName VARCHAR(100),
        Expression VARCHAR(1000),
        WordVec EMBEDDING('smallmodel-sentence-transformers-config','Word')
    )
    )
    if SQLCODE<0 {
        write %msg,!
        return
    }
    &sql(
    CREATE INDEX WordIdx On NLP.MetaInfo (Word)
    )
    &sql(
    CREATE INDEX HNSWIndex ON TABLE NLP.MetaInfo (WordVec)
    AS HNSW(Distance='Cosine')
    )
    /*
    do ..loadcsv()
    set start=$ZH
    write !,"WordカラムEmbedding開始",!
    do ..Vector()
    set end=$ZH
    write "Embeddingにかかった時間：",end-start,!
    */
}

/// Word,Column,MDXColumn,TableName,Cube,Expression
/// stsb-xlm-r-multilingual のモデルを使うパタン
ClassMethod createMetaInfoBCK()
{
    &sql(
    INSERT INTO %Embedding.Config (Name, Configuration, EmbeddingClass, VectorLength, Description)
    VALUES ('my-sentenceTransformer-config', 
            '{"modelName": "sentence-transformers/stsb-xlm-r-multilingual",
            "hfToken":"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",
            "hfCachePath": "/home/irisowner/.cache/huggingface/hub/models--sentence-transformers--stsb-xlm-r-multilingual"}',
            '%Embedding.SentenceTransformers',
            384,  
            'a multi language model provided by SentenceTransformers') 
    )
    if SQLCODE<0 {
        write %msg,!
        return
    }
    &sql(
    CREATE TABLE NLP.MetaInfo (
        Word VARCHAR(1000),
        Column VARCHAR(50),
        MDXColumn VARCHAR(100),
        TableName VARCHAR(100),
        CubeName VARCHAR(100),
        Expression VARCHAR(1000),
        WordVec VECTOR(DOUBLE,384)
    )
    )
    if SQLCODE<0 {
        write %msg,!
        return
    }
    &sql(
        CREATE INDEX WordIdx On NLP.MetaInfo (Word)
    )
    /*
    do ..loadcsv()
    set start=$ZH
    write !,"WordカラムEmbedding開始",!
    do ..Vector()
    set end=$ZH
    write "Embeddingにかかった時間：",end-start,!
    */
}

}
