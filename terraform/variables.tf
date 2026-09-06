# 外から変更できる値を定義

variable "project_id" {
  description = "GCPプロジェクトID"
  type        = string
  default     = "learning-data-platform-505213"
}

# Cloud Run、Compute Engineなど
variable "region" {
  description = "デフォルトのGCPリージョン"
  type        = string
  default     = "asia-northeast2"
}

# BigQuery特有の設定
variable "bigquery_location" {
  description = "BigQuery datasetを作成するロケーション"
  type        = string
  default     = "asia-northeast2"
}

variable "dataset_id" {
  description = "BigQuery datasetのID"
  type        = string
  default     = "learning"
}

variable "github_repository" {
  description = "GitHubリポジトリ"
  type        = string
  default     = "MikiKumagai/learning-data-platform"
}

variable "workload_identity_pool_id" {
  description = "GitHub Actions用Workload Identity PoolのID"
  type        = string
  default     = "github"
}

variable "workload_identity_provider_id" {
  description = "GitHub Actions用OIDCプロバイダのID"
  type        = string
  default     = "github"
}

