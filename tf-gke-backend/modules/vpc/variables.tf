variable "project_id" {
  description = "project id"
  type        = string
}

variable "region" {
  description = "region"
  default     = "europe-west1"
  type        = string
}

variable "name" {
  description = "name of the docker app"
  type        = string
}
