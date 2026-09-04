data "google_project" "current" {
  project_id = var.project_id
}

resource "google_service_account" "data_pipeline" {
  project      = var.project_id
  account_id   = "data-pipeline"
  display_name = "Learning Data Pipeline"
  description  = "Loads source data from SQLite into BigQuery."

  depends_on = [
    google_project_service.project_services["iam.googleapis.com"],
  ]
}

resource "google_service_account" "github_actions" {
  project      = var.project_id
  account_id   = "github-actions"
  display_name = "GitHub Actions"
  description  = "Runs dbt CI from GitHub Actions."

  depends_on = [
    google_project_service.project_services["iam.googleapis.com"],
  ]
}

resource "google_project_iam_member" "data_pipeline_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = google_service_account.data_pipeline.member
}

resource "google_project_iam_member" "github_actions_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = google_service_account.github_actions.member
}

resource "google_bigquery_dataset_iam_member" "data_pipeline_data_editor" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.learning.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_service_account.data_pipeline.member
}

resource "google_bigquery_dataset_iam_member" "github_actions_data_editor" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.learning.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_service_account.github_actions.member
}

resource "google_iam_workload_identity_pool" "github" {
  project                   = var.project_id
  workload_identity_pool_id = var.workload_identity_pool_id
  display_name              = "GitHub Actions Pool"
  description               = "Allows GitHub Actions to authenticate to GCP."

  depends_on = [
    google_project_service.project_services["iam.googleapis.com"],
  ]
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_provider_id
  display_name                       = "GitHub Actions Provider"
  description                        = "OIDC provider for GitHub Actions."

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }

  attribute_condition = "assertion.repository == '${var.github_repository}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "github_actions_workload_identity_user" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository/${var.github_repository}"
}
