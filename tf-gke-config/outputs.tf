output "bucket_name" {
  value = google_storage_bucket.tf_state.name
}

output "google_artifact_registry_name" {
  value = google_artifact_registry_repository.streamlit_repo.id
}
