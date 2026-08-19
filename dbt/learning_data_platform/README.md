# learning_data_platform dbt Project

学習管理アプリのデータをBigQuery上で分析しやすい形に変換するためのdbtプロジェクトです。

## Structure

```text
models/
├── staging/       # BigQueryのsourceテーブルを整える層
├── intermediate/  # 分析用の中間集計・結合
└── marts/         # 利用しやすい最終テーブル
```

sourceテーブルは `models/sources.yml` で定義しています。

## Setup

リポジトリ直下から以下を実行します。

```bash
cd dbt
python3 -m venv .venv
source .venv/bin/activate
python -m pip install dbt-bigquery
```

BigQuery接続用に `~/.dbt/profiles.yml` を設定します。

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

## Commands

`dbt_project.yml` があるこのディレクトリで実行します。

```bash
source ../.venv/bin/activate
dbt debug
dbt run
dbt test
```

リポジトリ直下で実行したい場合は、`--project-dir` を指定します。

```bash
dbt --project-dir dbt/learning_data_platform run
```
