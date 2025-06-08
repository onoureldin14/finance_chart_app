# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "grafana_service_external_ip" {
  value       = module.kubernetes.grafana_service_ip
  description = "Public IP of the Grafana service"
}

output "prometheus_service_external_ip" {
  value       = module.kubernetes.prometheus_service_ip
  description = "Public IP of the Prometheus service"
}

output "streamlit_service_external_ip" {
  value       = module.kubernetes.streamlit_service_ip
  description = "Public IP of the Streamlit app"
}
