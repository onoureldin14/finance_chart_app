locals {
  google_storage_bucket_name    = "${var.project_id}-tfstate-${random_id.bucket_suffix.hex}"
  google_artifact_registry_name = "${var.name}-repo"
}
