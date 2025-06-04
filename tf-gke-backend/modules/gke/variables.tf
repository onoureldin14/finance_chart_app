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


variable "gke_num_nodes" {
  default     = 4
  description = "number of gke nodes"
  type        = number
}

variable "gke_machine_type" {
  default     = "n1-standard-1"
  description = "machine type for gke nodes"
  type        = string
}

variable "disk_size_gb" {
  default     = 50
  description = "disk size in GB for gke nodes"
  type        = number
}

variable "service_account_id" {
  description = "service account email"
  type        = string
  default     = "service-account-id"
}

variable "vpc_name" {
  description = "name of the vpc"
  type        = string
}
variable "subnet_name" {
  description = "name of the subnet"
  type        = string
}
