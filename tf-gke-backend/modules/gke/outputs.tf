output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}
output "kubernetes_cluster_host_ip" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host IP"
}
output "kubernetes_cluster_ca_certificate" {
  value       = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  description = "GKE Cluster CA Certificate"
}
output "gke_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}
