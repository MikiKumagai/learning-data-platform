# Metabaseから学習データを参照するためのサービスアカウント。
resource "google_service_account" "metabase" {
  project      = var.project_id
  account_id   = "metabase"
  display_name = "Metabase"
  description  = "MetabaseからBigQueryの学習データを参照するサービスアカウント"

  depends_on = [
    google_project_service.project_services["iam.googleapis.com"],
  ]
}

resource "google_project_iam_member" "metabase_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = google_service_account.metabase.member
}

resource "google_bigquery_dataset_iam_member" "metabase_data_viewer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.learning.dataset_id
  role       = "roles/bigquery.dataViewer"
  member     = google_service_account.metabase.member
}

resource "google_bigquery_dataset_iam_member" "metabase_metadata_viewer" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.learning.dataset_id
  role       = "roles/bigquery.metadataViewer"
  member     = google_service_account.metabase.member
}
