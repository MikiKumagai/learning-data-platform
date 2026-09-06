# BigQueryリソースを管理
resource "google_bigquery_dataset" "learning" {
  dataset_id  = var.dataset_id
  project     = var.project_id
  location    = var.bigquery_location
  description = "学習管理アプリの分析用dataset"

  labels = {
    project = "learning-data-platform"
    layer   = "analytics"
  }

  depends_on = [
    google_project_service.project_services["bigquery.googleapis.com"],
  ]
}
