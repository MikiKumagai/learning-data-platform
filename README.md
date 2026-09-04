# Learning Data Platform

個人開発している学習管理アプリのデータを利用して、データ基盤の構築・運用について学ぶための個人プロジェクトです。

## 概要

学習管理アプリでは、SQLiteに学習タスクや進捗データを保存しています。

このプロジェクトでは、SQLiteに蓄積したデータをPythonでBigQueryにロードし、SQLとdbtで複数のテーブルを結合・加工することで、分析しやすいデータを作成します。

## Architecture

```text
Learning Management App
        │
        │ SQLite
        ↓
  Python Pipeline
        │
        ↓
    BigQuery
        │
        │ SQL / dbt
        ↓
  Analysis-ready Data
```

## Responsibilities

このリポジトリでは、各レイヤーの責務を次のように分けています。

| Layer | Responsibility |
|---|---|
| Terraform | GCP API、BigQuery dataset、service account、IAM、Workload Identity Federationを管理 |
| Python Pipeline | SQLiteからBigQuery source tableへのデータロードとschema指定 |
| dbt | BigQuery上のデータ変換、分析用view / table、データテストを管理 |
| SQL | dbt導入前に使った練習・確認用SQLを保存 |

## Data Model

BigQueryには、学習管理アプリのデータ構造をもとに以下のテーブルを作成しています。

```text
progress
   │
   │ task_id
   ↓
task
   │
   ├── progress_type_id → progress_type
   │
   └── progress_unit_id → progress_unit
```

### Tables

| Table | Description |
|---|---|
| `task` | 学習タスク |
| `progress` | タスクごとの進捗記録 |
| `progress_type` | 進捗形式のマスタ（累計・差分） |
| `progress_unit` | 進捗単位のマスタ（ページ・問・章・セクション） |

## Learning Progress

- BigQueryの基本的な使い方
- CSVからBigQueryへのデータ取り込み
- BigQueryにおけるテーブル・データセットの構造
- SQLによる複数テーブルのJOIN
- アプリケーション用データを分析しやすい形に変換する方法
- dbtによるデータ変換・データモデル構築
- staging / intermediate / marts によるデータモデルの整理
- データマートの設計・実装
- SQLを用いたデータ分析
- データパイプラインの自動化
- CI/CDによるデータ基盤の運用
- データ品質管理・テスト
- TerraformによるGCP / BigQueryリソース管理

## Pipeline

`pipeline/` ディレクトリには、SQLiteからBigQueryへデータをロードするPythonスクリプトを置いています。

```text
pipeline/
└── pipeline.py
```

SQLite側の `progresses` テーブルを読み込み、BigQuery側の `learning.progress` テーブルへロードします。

必要な環境変数は `.env` に設定します。

```text
SQLITE_DB_PATH=/path/to/progress.db
GCP_PROJECT_ID=learning-data-platform-505213
BQ_DATASET=learning
```

## SQL

`sql/` ディレクトリにBigQueryで使用したSQLを保存しています。
dbt導入前の練習SQLです。

```text
sql/
├── 01_join_learning_data.sql
├── 02_create_task_progress_summary.sql
└── 03_check_data_quality.sql
```

## dbt

`dbt/learning_data_platform/` ディレクトリにdbtプロジェクトを配置しています。

```text
dbt/learning_data_platform/
├── dbt_project.yml
└── models/
    ├── analysis/
    ├── staging/
    ├── intermediate/
    └── marts/
```

セットアップと実行手順は `dbt/learning_data_platform/README.md` にまとめています。

## Terraform

`terraform/` ディレクトリでは、GCP / BigQuery の基盤を管理します。

```text
terraform/
├── apis.tf
├── bigquery.tf
├── iam.tf
├── providers.tf
├── variables.tf
└── versions.tf
```

詳しい手順は `terraform/README.md` にまとめています。

## Lint / CI

SQLのlintにはSQLFluffを使用しています。

```bash
dbt/.venv/bin/sqlfluff lint dbt/learning_data_platform/models
```

GitHub Actionsでは、dbtの検証を実行するためのワークフローを管理しています。

## Future Plans

- Pythonを用いたデータ分析・機械学習
- AWSなどのクラウドサービスを利用したデータ基盤の構築

## Background

Webアプリケーション開発の経験に加えて、データを扱うことへの関心が強くなったことから、データエンジニアリング領域への理解を深めるために本プロジェクトを始めました。

実際に個人開発で蓄積したデータを利用しながら、データの取り込み・変換・蓄積・分析までの流れを実践的に学んでいきます。
