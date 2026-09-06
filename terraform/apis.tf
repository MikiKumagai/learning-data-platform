# API有効化を管理

# 利用するGCP APIの一覧
locals {
  project_services = toset([
    "bigquery.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
  ])
}

# 各APIのリソースを作る
# Terraform設定を消しても既存のAPI利用を止めない
resource "google_project_service" "project_services" {
  for_each = local.project_services

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

