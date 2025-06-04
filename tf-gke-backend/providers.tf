# # Kubernetes provider
# # The Terraform Kubernetes Provider configuration below is used as a learning reference only.
# # It references the variables and resources provisioned in this file.
# # We recommend you put this in another file -- so you can have a more modular configuration.
# # https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster#optional-configure-terraform-kubernetes-provider
# # To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider.
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

provider "kubernetes" {
  host                   = "https://${module.gke.kubernetes_cluster_host}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = module.gke.kubernetes_cluster_ca_certificate
}

provider "helm" {
  kubernetes = {
    host                   = "https://${module.gke.kubernetes_cluster_host}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = module.gke.kubernetes_cluster_ca_certificate
  }
}
