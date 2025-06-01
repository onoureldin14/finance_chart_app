resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "tf_state" {
  name     = "${var.project_id}-tfstate-${random_id.bucket_suffix.hex}"
  location = var.region
  project  = var.project_id

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}
