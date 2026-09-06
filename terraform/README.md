# Terraform

このディレクトリでは、Learning Data Platform の GCP / BigQuery 基盤を管理する。

## Scope

Terraformでは、次のGCP / BigQuery基盤を管理

- 既存GCP project上のAPI / IAM
- BigQuery dataset: `learning`
- 必要なGCP API
- data pipeline用 service account
- GitHub Actions用 service account
- BigQuery実行・編集に必要なIAM
- GitHub Actions用 Workload Identity Federation

## Setup

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
```

既存のGCPリソースをTerraform管理に移す場合は、最初に import が必要

```bash
terraform import google_bigquery_dataset.learning projects/learning-data-platform-505213/datasets/learning
terraform import google_service_account.github_actions projects/learning-data-platform-505213/serviceAccounts/github-actions@learning-data-platform-505213.iam.gserviceaccount.com
terraform import google_iam_workload_identity_pool.github projects/learning-data-platform-505213/locations/global/workloadIdentityPools/github
terraform import google_iam_workload_identity_pool_provider.github projects/learning-data-platform-505213/locations/global/workloadIdentityPools/github/providers/github
```

`data-pipeline` service account を手動作成済みの場合は、以下も import

```bash
terraform import google_service_account.data_pipeline projects/learning-data-platform-505213/serviceAccounts/data-pipeline@learning-data-platform-505213.iam.gserviceaccount.com
```

## Apply

`terraform plan` の内容を確認してから適用

```bash
terraform apply
```

GitHub Actionsの認証設定には、apply後の `github_actions_workload_identity_provider` output と `github_actions_service_account_email` output を使う。
