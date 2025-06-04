resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "tf_state" {
  name     = local.google_storage_bucket_name
  location = var.region
  project  = var.project_id

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}


resource "google_artifact_registry_repository" "streamlit_repo" {
  location      = var.region
  project       = var.project_id
  repository_id = local.google_artifact_registry_name
  format        = "DOCKER"
}
