# Learning Data Platform

個人開発している学習管理アプリのデータを利用して、データ基盤の構築・運用について学ぶための個人プロジェクトです。

## 概要

学習管理アプリでは、SQLiteに学習タスクや進捗データを保存しています。

このプロジェクトでは、SQLiteに蓄積したデータをBigQueryに取り込み、SQLとdbtで複数のテーブルを結合・加工することで、分析しやすいデータを作成します。

## Architecture

```text
Learning Management App
        │
        │ SQLite
        ↓
      CSV
        │
        ↓
    BigQuery
        │
        │ SQL / dbt
        ↓
  Analysis-ready Data
```

## Data Model

BigQueryには、学習管理アプリのデータ構造をもとに以下のテーブルを作成しています。

```text
progress
   │
   │ task_id
   ↓
tasks
   │
   ├── progress_type_id → progress_types
   │
   └── progress_unit_id → progress_units
```

### Tables

| Table | Description |
|---|---|
| `tasks` | 学習タスク |
| `progress` | タスクごとの進捗記録 |
| `progress_types` | 進捗形式のマスタ（累計・差分） |
| `progress_units` | 進捗単位のマスタ（ページ・問・章・セクション） |

## What I Have Learned

- BigQueryの基本的な使い方
- CSVからBigQueryへのデータ取り込み
- BigQueryにおけるテーブル・データセットの構造
- SQLによる複数テーブルのJOIN
- アプリケーション用データを分析しやすい形に変換する方法

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
    ├── staging/
    ├── intermediate/
    └── marts/
```

### Setup

dbtコマンドが見つからない場合は、仮想環境を作成してdbt-bigqueryをインストールします。

```bash
cd dbt
python3 -m venv .venv
source .venv/bin/activate
python -m pip install dbt-bigquery
```

BigQueryに接続するため、`~/.dbt/profiles.yml` に `learning_data_platform` プロファイルを用意します。

```yaml
learning_data_platform:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: oauth
      project: learning-data-platform-505213
      dataset: learning
      threads: 4
      timeout_seconds: 300
```

### Run

dbtは `dbt_project.yml` があるディレクトリで実行します。

```bash
cd dbt/learning_data_platform
source ../.venv/bin/activate
dbt debug
dbt run
dbt test
```

リポジトリ直下で `dbt run` を実行すると、`dbt_project.yml` が見つからず失敗します。

## Future Plans

今後、以下について学習・実装する予定です。

- データマートの設計
- AWSなどのクラウドサービスを利用したデータ基盤
- データパイプラインの自動化
- CI/CDによるデータ基盤の運用

## Background

Webアプリケーション開発の経験に加えて、データを扱うことへの関心が強くなったことから、データエンジニアリング領域への理解を深めるために本プロジェクトを始めました。

実際に個人開発で蓄積したデータを利用しながら、データの取り込み・変換・蓄積・分析までの流れを実践的に学んでいきます。
