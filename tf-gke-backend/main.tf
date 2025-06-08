# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

###################################################################
# VPC
###################################################################
module "vpc" {
  source     = "./modules/vpc"
  project_id = var.project_id
  region     = var.region
  name       = var.name
}



###################################################################
# GKE
###################################################################
module "gke" {
  source      = "./modules/gke"
  project_id  = var.project_id
  region      = var.region
  name        = var.name
  vpc_name    = module.vpc.vpc_name
  subnet_name = module.vpc.subnet_name
}

###################################################################
# Kubernetes
###################################################################

module "kubernetes" {
  source           = "./modules/kubernetes"
  name             = var.name
  project_id       = var.project_id
  docker_image_id  = data.google_artifact_registry_docker_image.streamlit_image.self_link
  gke_cluster_name = module.gke.gke_cluster_name
  depends_on       = [module.gke]
}
