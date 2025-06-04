output "streamlit_service_external_ip" {
  value       = kubernetes_service.streamlit.status[0].load_balancer[0].ingress[0].ip
  description = "Public IP of the Streamlit app"
}
