output "grafana_service_ip" {
  value       = "http://${data.kubernetes_service.grafana.status[0].load_balancer[0].ingress[0].ip}"
  description = "The external IP of the Grafana service"
}

output "prometheus_service_ip" {
  value       = "http://${data.kubernetes_service.prometheus-server.status[0].load_balancer[0].ingress[0].ip}"
  description = "The external IP of the Prometheus service"
}

output "streamlit_service_ip" {
  value       = "http://${kubernetes_service.streamlit.status[0].load_balancer[0].ingress[0].ip}"
  description = "The external IP of the Streamlit service"
}
