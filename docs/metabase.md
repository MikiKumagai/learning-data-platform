# MetabaseとBigQueryの接続

Metabaseから、dbtがBigQueryに作成した学習データを参照する。

## 0. Metabaseを起動

Docker Desktopを起動し、初回は次のコマンドでMetabaseのコンテナを作成・起動する。

```bash
docker run -d -p 3000:3000 --name metabase metabase/metabase
```

起動が完了したら http://localhost:3000/browse/databases/2-kmmk-bigquery を開き、初回セットアップで管理者アカウントを作成する。
BigQueryの接続設定は、以下の手順で行う。

作成済みのコンテナが停止している場合は、次のコマンドで起動する。

```bash
docker start metabase
```

## 1. 接続用サービスアカウントを作成

リポジトリ直下から実行する。

```bash
terraform -chdir=terraform init
terraform -chdir=terraform plan
```

`metabase.tf` は専用サービスアカウントと次の権限を追加する。

| 対象 | 権限 |
|---|---|
| GCPプロジェクト | BigQuery Job User |
| `learning` データセット | BigQuery Data Viewer / BigQuery Metadata Viewer |

planで既存リソースへの意図しない変更がないことを確認し、適用する。

```bash
terraform -chdir=terraform apply
terraform -chdir=terraform output -raw metabase_service_account_email
```

## 2. JSONキーを用意

リポジトリ直下に `metabase-key.json` を作成済みの場合は、そのファイルを使う。
このファイルは `.gitignore` の `*-key.json` によりGit管理対象外になっている。
未作成の場合は、次の手順で用意する。

Google Cloud Consoleで、対象プロジェクトの「IAMと管理」→「サービスアカウント」を開く。
上で作成した `metabase` の「鍵」→「鍵を追加」→「新しい鍵を作成」→「JSON」を選択する。
ダウンロードしたファイルはリポジトリ外に保管し、Metabaseの接続画面で使用する。

キーはTerraformでは生成しない。秘密鍵がTerraformのstateに保存されるのを避けるため。

## 3. Metabaseで接続を追加

管理者でログインし、「管理」→「データベース」→「データベースを追加」を開く。

| 設定項目 | 入力値 |
|---|---|
| データベースの種類 | Google BigQuery |
| 表示名 | Learning Data Platform |
| Project ID | `learning-data-platform-505213` |
| Service account JSON file | 手順2でダウンロードしたJSONファイル |
| Datasets | Only these… → `learning` |

上記はリポジトリのデフォルト値。Terraform変数を変更している場合は、
`terraform -chdir=terraform output -raw project_id` と
`terraform -chdir=terraform output -raw dataset_id` の値を使う。

保存後にスキーマの同期を待つ。

## 4. 接続を確認

Metabaseで新しいSQLクエリを作成し、追加したデータベースを選んで実行する。

```sql
SELECT table_name, table_type
FROM `learning-data-platform-505213.learning.INFORMATION_SCHEMA.TABLES`
ORDER BY table_name;
```

dbtのモデルが作成済みなら、`daily_learning` や `task_progress_summary` が表示される。
これらがない場合は、dbtのセットアップ後、リポジトリ直下で次を実行し、Metabaseのスキーマを再同期する。

```bash
dbt/.venv/bin/dbt --project-dir dbt/learning_data_platform run
```

最初の可視化には、`task_progress_summary` の `task_name` と `progress_rate` を使った棒グラフを作成できる。

公式手順: [Metabase — Google BigQuery](https://www.metabase.com/docs/latest/databases/connections/bigquery)
