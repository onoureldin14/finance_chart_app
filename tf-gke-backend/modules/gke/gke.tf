###################################################################
# Google Cluster and Node Pool
###################################################################

resource "google_container_cluster" "primary" {
  name     = local.cluster_name
  project  = var.project_id
  location = "${var.region}-b"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network             = var.vpc_name
  subnetwork          = var.subnet_name
  deletion_protection = false
  addons_config {
    http_load_balancing {
      disabled = false # ✅ Enable the GKE ingress controller
    }
  }

}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name     = google_container_cluster.primary.name
  project  = var.project_id
  location = "${var.region}-b"
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
    machine_type = var.gke_machine_type
    disk_size_gb = var.disk_size_gb
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
