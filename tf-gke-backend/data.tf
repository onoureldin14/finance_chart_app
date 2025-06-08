data "google_client_config" "default" {}


data "google_artifact_registry_docker_image" "streamlit_image" {
  project       = var.project_id
  location      = var.region
  repository_id = var.docker_repo_name
  image_name    = "${var.name}:${var.docker_image_version}"
}
