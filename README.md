# Learning Data Platform

個人開発している学習管理アプリのデータを利用して、データ基盤の構築・運用について学ぶための個人プロジェクトです。

## 概要

学習管理アプリでは、SQLiteに学習タスクや進捗データを保存しています。

このプロジェクトでは、SQLiteに蓄積したデータをBigQueryに取り込み、複数のテーブルを結合・加工することで、分析しやすいデータを作成します。

今後はdbtなども利用し、データの変換・管理について学習していく予定です。

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

```text
sql/
├── create_progress_types.sql
├── create_progress_units.sql
└── learning_progress.sql
```

## Future Plans

今後、以下について学習・実装する予定です。

- dbtによるデータ変換処理の管理
- データマートの設計
- AWSなどのクラウドサービスを利用したデータ基盤
- データパイプラインの自動化
- CI/CDによるデータ基盤の運用

## Background

Webアプリケーション開発の経験に加えて、データを扱うことへの関心が強くなったことから、データエンジニアリング領域への理解を深めるために本プロジェクトを始めました。

実際に個人開発で蓄積したデータを利用しながら、データの取り込み・変換・蓄積・分析までの流れを実践的に学んでいきます。