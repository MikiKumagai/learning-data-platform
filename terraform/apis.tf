locals {
  project_services = toset([
    "bigquery.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
  ])
}

resource "google_project_service" "project_services" {
  for_each = local.project_services

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

