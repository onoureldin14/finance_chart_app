###################################################################
# VPC & Subnet
###################################################################

resource "google_compute_network" "vpc" {
  name                    = "${var.name}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name             = "${var.name}-subnet"
  project          = var.project_id
  region           = var.region
  network          = google_compute_network.vpc.name
  ip_cidr_range    = "10.10.0.0/24"
  stack_type       = "IPV4_IPV6"
  ipv6_access_type = "EXTERNAL"
}
