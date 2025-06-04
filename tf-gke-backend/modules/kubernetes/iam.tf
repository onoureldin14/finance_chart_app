###################################################################
# Google Service Account and IAM Permissions
###################################################################

resource "google_service_account" "loki" {
  project      = var.project_id
  account_id   = "gcs-bucket-loki-sa"
  display_name = "Service account for Loki"
}

resource "google_project_iam_member" "loki" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.loki.email}"
}

resource "google_service_account_key" "loki_key" {
  service_account_id = google_service_account.loki.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"
}
