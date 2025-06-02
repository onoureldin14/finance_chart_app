# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

###################################################################
# VPC & Subnet
###################################################################

resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name             = "${var.project_id}-subnet"
  project          = var.project_id
  region           = var.region
  network          = google_compute_network.vpc.name
  ip_cidr_range    = "10.10.0.0/24"
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"
}


###################################################################
# Google Artifact Registry
###################################################################


resource "google_artifact_registry_repository" "my_repo" {
  location      = var.region
  project       = var.project_id
  repository_id = "finance-app-repo"
  format        = "DOCKER"
}

###################################################################
# Google Service Account and IAM Permissions
###################################################################

resource "google_service_account" "default" {
  project      = var.project_id
  account_id   = "service-account-id"
  display_name = "Service Account"
}

resource "google_project_iam_member" "artifact_registry_pull" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.default.email}"
}

###################################################################
# Google Cluster and Node Pool
###################################################################

resource "google_container_cluster" "primary" {
  name     = local.cluster_name
  project  = var.project_id
  location = local.single_zone_location

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network             = google_compute_network.vpc.name
  subnetwork          = google_compute_subnetwork.subnet.name
  deletion_protection = false
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name     = google_container_cluster.primary.name
  project  = var.project_id
  location = local.single_zone_location
  cluster  = google_container_cluster.primary.name

  version    = data.google_container_engine_versions.gke_version.release_channel_default_version["STABLE"]
  node_count = var.gke_num_nodes

  node_config {
    service_account = google_service_account.default.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/cloud-platform"

    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
