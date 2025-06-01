variable "project_id" {
  description = "project id"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "region"
  default     = "europe-west1"
  type        = string
}
