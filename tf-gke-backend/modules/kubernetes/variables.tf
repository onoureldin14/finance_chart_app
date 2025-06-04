variable "project_id" {
  description = "project id"
  type        = string
}

variable "region" {
  description = "region"
  default     = "europe-west1"
  type        = string
}

variable "grafana_helm_repository" {
  description = "Grafana Helm repository URL"
  type        = string
  default     = "https://grafana.github.io/helm-charts"
}

variable "name" {
  description = "name of the docker app"
  type        = string
}

variable "docker_image_id" {
  description = "Docker image ID"
  type        = string
}

variable "gke_cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "monitoring_enabled" {
  description = "Enable monitoring with Grafana"
  type        = bool
  default     = true
}
