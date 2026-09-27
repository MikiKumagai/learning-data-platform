# learning-data-platform

学習管理アプリのデータを使って、データ基盤の構築・運用を学ぶ個人プロジェクト。

SQLiteのデータをBigQueryに取り込み、dbtで変換・データマートを作成し、Metabaseで可視化する。

## 概要

```text
Learning Management App
        │
      SQLite
        ↓
  Python Pipeline
        ↓
    BigQuery
        ↓
     dbt
        ↓
   Data Mart
        ↓
    Metabase
```

## 使用技術

* **GCP / BigQuery** — データ基盤
* **Python** — データロード
* **dbt** — データ変換・データモデリング
* **SQL** — データ加工
* **Metabase** — データの可視化
* **Terraform** — GCP / BigQueryのインフラ管理
* **GitHub Actions** — CI
* **SQLFluff** — SQL lint

## 学習内容

* BigQueryへのデータ取り込み
* SQLによるデータ加工
* dbtによるデータモデリング
* staging / intermediate / marts の設計
* データ品質テスト
* Terraformによるインフラ管理
* GitHub ActionsによるCI
* Metabaseによるデータマートの可視化

## ディレクトリ構成

```text
├── pipeline/                    # SQLite → BigQuery → dbt
├── dbt/learning_data_platform/  # データ変換モデル・テスト
├── terraform/                   # GCP / BigQuery
├── sql/                         # SQLの練習・確認
├── docs/                        # 各種手順
└── .github/workflows/            # GitHub Actions
```

## 今後

* Pythonによるデータ分析
* Airflow
