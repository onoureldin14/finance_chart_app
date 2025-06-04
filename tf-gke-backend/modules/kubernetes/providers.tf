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
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre2"
    }

  }
  required_version = ">= 0.13"
}
