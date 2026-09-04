variable "project_id" {
  description = "GCP project ID for the learning data platform."
  type        = string
  default     = "learning-data-platform-505213"
}

variable "region" {
  description = "Default GCP region."
  type        = string
  default     = "asia-northeast2"
}

variable "bigquery_location" {
  description = "Location for BigQuery datasets."
  type        = string
  default     = "asia-northeast2"
}

variable "dataset_id" {
  description = "BigQuery dataset ID used by the pipeline and dbt."
  type        = string
  default     = "learning"
}

variable "github_repository" {
  description = "GitHub repository allowed to impersonate the CI service account."
  type        = string
  default     = "MikiKumagai/learning-data-platform"
}

variable "workload_identity_pool_id" {
  description = "Workload Identity Pool ID for GitHub Actions."
  type        = string
  default     = "github"
}

variable "workload_identity_provider_id" {
  description = "Workload Identity Provider ID for GitHub Actions."
  type        = string
  default     = "github"
}

