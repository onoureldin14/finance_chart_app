###################################################################
# Google Service Account and IAM Permissions
###################################################################

resource "google_service_account" "default" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = "Service Account"
}

resource "google_project_iam_member" "artifact_registry_pull" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.default.email}"
}
