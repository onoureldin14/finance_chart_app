terraform {
  backend "gcs" {
    bucket = "security-vmt-tfstate-214a42b5"
    # bucket  = "REPLACE_WITH_BUCKET_NAME"
    prefix = "terraform/state"
  }
}
