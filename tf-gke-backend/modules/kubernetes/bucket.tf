resource "google_storage_bucket" "loki" {
  name     = "${var.project_id}-loki"
  location = var.region
  project  = var.project_id

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true


  force_destroy = true
}
