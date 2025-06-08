variable "project_id" {
  description = "project id"
  type        = string
}

variable "grafana_helm_repository" {
  description = "Grafana Helm repository URL"
  type        = string
  default     = "https://grafana.github.io/helm-charts"
}

variable "prometheus_helm_repository" {
  description = "Prometheus Helm repository URL"
  type        = string
  default     = "https://prometheus-community.github.io/helm-charts"

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

variable "helm_timeout" {
  description = "Timeout for Helm operations"
  type        = number
  default     = 600
}

variable "prometheus_chart_name" {
  description = "Name of the Prometheus Helm chart"
  type        = string
  default     = "prometheus"
}

variable "grafana_helm_chart_name" {
  description = "Name of the Grafana Helm chart"
  type        = string
  default     = "grafana"
}

variable "loki_chart_name" {
  description = "Name of the Loki Helm chart"
  type        = string
  default     = "loki"
}

variable "grafana_monitoring_stack_chart_name" {
  description = "Name of the Grafana monitoring stack Helm chart"
  type        = string
  default     = "k8s-monitoring"
}

variable "loki_service_account_name" {
  description = "Name of the service account for Loki GCS bucket access"
  type        = string
  default     = "gcs-bucket-loki-sa"
}

variable "monitoring_namespace" {
  description = "Namespace for monitoring resources"
  type        = string
  default     = "default"
}

variable "application_namespace" {
  description = "Namespace for the application"
  type        = string
  default     = "prod"
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  sensitive   = true
  default     = "adminadminadmin"
}

variable "grafana_admin_user" {
  description = "Admin user for Grafana"
  type        = string
  default     = "admin"
}
