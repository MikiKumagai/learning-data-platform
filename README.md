# Learning Data Platform

個人開発した学習管理アプリのデータを利用して、データ基盤の構築・運用について学ぶための個人プロジェクト

## 概要

このプロジェクトでは、学習管理アプリのデータをBigQueryに集約し、dbtで学習量・進捗率・学習ペースを分析できるデータに加工する。Metabaseを可視化に、TerraformをGCP基盤の管理に利用する。

## Architecture

```text
Learning Management App
        │
        │ SQLite（progresses）
        ↓
  Python Pipeline
        │
        ↓
    BigQuery（learning）← タスク・マスタを事前に取り込み
        │
        │ dbt: staging → intermediate → marts / analysis
        ↓
  Analysis-ready Data
        │
        ↓
     Metabase
```

## Directory Structure

```text
.
├── pipeline/                    # SQLite → BigQuery → dbt の実行スクリプト
├── dbt/learning_data_platform/   # データ変換モデルとデータテスト
├── terraform/                   # GCP / BigQuery基盤の定義
├── sql/                         # dbt導入前の練習・確認用SQL
├── docs/metabase.md             # Metabaseの起動・接続手順
└── .github/workflows/dbt.yml     # dbt CI
```

## Setup

### 前提

- Python（CIでは3.13を使用）
- Google Cloud CLIと、BigQueryのジョブ実行・対象データセットの編集権限
- Terraform 1.6.0以上（基盤の作成・変更時）
- Docker Desktop（Metabaseの利用時）
- 学習管理アプリのSQLiteデータベース

GCP基盤は [Terraformの手順](terraform/README.md) に従って準備する。

### Python環境と認証

以下のコマンドはリポジトリ直下で実行する。

```bash
python3 -m venv dbt/.venv
source dbt/.venv/bin/activate
python -m pip install pandas python-dotenv google-cloud-bigquery pyarrow dbt-bigquery sqlfluff sqlfluff-templater-dbt
gcloud auth application-default login
```

続いて [dbtのセットアップ手順](dbt/learning_data_platform/README.md#setup) に従い、`~/.dbt/profiles.yml` の `learning_data_platform` プロファイルを設定する。BigQueryの `location` は対象データセットに合わせる（Terraformのデフォルトは `asia-northeast2`）。

デフォルトの接続先はプロジェクト `learning-data-platform-505213`、データセット `learning`。変更する場合は、Terraform変数、以下の `.env`、dbtプロファイルに加えて、[sources.yml](dbt/learning_data_platform/models/sources.yml) と [CIワークフロー](.github/workflows/dbt.yml) の固定値も合わせて変更する。

## Pipeline

`pipeline/pipeline.py` はSQLiteの `progresses` をBigQueryの `learning.progress` へ全件置換でロードし、`dbt run` を実行する。既存の `progress` データは上書きされる。

必要な環境変数はリポジトリ直下の `.env` に設定する。

```text
SQLITE_DB_PATH=/path/to/progress.db
GCP_PROJECT_ID=learning-data-platform-505213
BQ_DATASET=learning
```

実行前に、同じデータセットへ `task`、`progress_type`、`progress_unit` テーブルを別途取り込んでおく。Pythonスクリプトのロード対象は `progress` のみ。

```bash
source dbt/.venv/bin/activate
python pipeline/pipeline.py
dbt --project-dir dbt/learning_data_platform test
```

`dbt test` は別途実行する。スクリプトは `dbt run` の失敗を終了コードに反映しないため、ログも確認する。

## dbt / 可視化

`staging → intermediate → marts / analysis` の構成でデータを加工し、タスク別の進捗率、日別の学習量、学習ペースなどを分析する。

モデルの構築とテストは、リポジトリ直下で実行する。

```bash
source dbt/.venv/bin/activate
dbt --project-dir dbt/learning_data_platform build
```

詳しい実行手順は [dbt README](dbt/learning_data_platform/README.md)、可視化の準備は [Metabase接続手順](docs/metabase.md) を参照。

## Lint / CI

SQLのlintにはSQLFluffを使用

```bash
dbt/.venv/bin/sqlfluff lint dbt/learning_data_platform/models
```

[GitHub Actions](.github/workflows/dbt.yml) は、`main` へのpushとpull requestでSQLFluff、`dbt debug`、`dbt build`、`dbt test` を実行する。認証にはWorkload Identity Federationを使用し、BigQueryの `learning` データセットにモデルを作成・更新する。
