terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.37.0"

    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.37.1"
    }
  }
  required_version = ">= 0.13"
}
