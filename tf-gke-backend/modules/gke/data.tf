data "google_container_engine_versions" "gke_version" {
  location       = var.region
  project        = var.project_id
  version_prefix = "1.32."
}
