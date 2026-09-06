# Terraformやproviderのバージョンを固定

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    # GCPリソースをTerraformから操作するための公式provider
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

