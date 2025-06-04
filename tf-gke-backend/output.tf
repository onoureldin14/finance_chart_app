# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


output "kubernetes_cluster_host" {
  value       = module.gke.kubernetes_cluster_host
  description = "GKE Cluster Host"
}

output "streamlit_service_external_ip" {
  value       = module.kubernetes.streamlit_service_external_ip
  description = "Public IP of the Streamlit app"
}
