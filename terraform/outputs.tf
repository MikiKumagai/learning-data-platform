output "project_id" {
  description = "GCP project ID managed by this Terraform configuration."
  value       = var.project_id
}

output "dataset_id" {
  description = "BigQuery dataset ID."
  value       = google_bigquery_dataset.learning.dataset_id
}

output "data_pipeline_service_account_email" {
  description = "Service account email for the local or scheduled data pipeline."
  value       = google_service_account.data_pipeline.email
}

output "github_actions_service_account_email" {
  description = "Service account email for GitHub Actions."
  value       = google_service_account.github_actions.email
}

output "workload_identity_provider" {
  description = "Workload Identity Provider resource name."
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "github_actions_workload_identity_provider" {
  description = "Provider name to use in google-github-actions/auth."
  value       = "projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${var.workload_identity_pool_id}/providers/${var.workload_identity_provider_id}"
}
