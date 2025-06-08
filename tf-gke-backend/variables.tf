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
  default     = "streamlit-app"
}

variable "docker_repo_name" {
  description = "name of the docker repository"
  type        = string
  default     = "streamlit-app-repo"
}

variable "docker_image_version" {
  description = "version of the docker image"
  type        = string
  default     = "latest"
}
