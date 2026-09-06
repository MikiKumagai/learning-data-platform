# 作成したリソースの値を外部へ出力

output "project_id" {
  description = "このTerraformで管理するGCPプロジェクトID"
  value       = var.project_id
}

output "dataset_id" {
  description = "BigQuery datasetのID"
  value       = google_bigquery_dataset.learning.dataset_id
}

output "data_pipeline_service_account_email" {
  description = "データパイプライン用サービスアカウントのメールアドレス"
  value       = google_service_account.data_pipeline.email
}

output "github_actions_service_account_email" {
  description = "GitHub Actions用サービスアカウントのメールアドレス"
  value       = google_service_account.github_actions.email
}

output "workload_identity_provider" {
  description = "OIDCプロバイダのリソース名"
  value       = google_iam_workload_identity_pool_provider.github.name
}

# google-github-actions/auth のOIDCプロバイダに設定する値
output "github_actions_workload_identity_provider" {
  description = "google-github-actions/authで使用するプロバイダ名"
  value       = "projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${var.workload_identity_pool_id}/providers/${var.workload_identity_provider_id}"
}
