###################################################################
# Grafana Dashboard Setup
###################################################################

resource "helm_release" "dashboard" {
  count      = var.monitoring_enabled ? 1 : 0
  name       = "grafana"
  repository = var.grafana_helm_repository
  chart      = "grafana"
  values     = [file("${path.module}/helm/grafana-dashboard-values.yaml")]
}




###################################################################
# Grafana Loki Logging Setup
###################################################################

resource "kubernetes_secret" "loki_gcp_sa" {
  metadata {
    name      = "loki-secrets"
    namespace = "meta"
  }
  data = {
    "gcp_service_account.json" = base64decode(google_service_account_key.loki_key.private_key)
  }
  type       = "Opaque"
  depends_on = [helm_release.dashboard]

}

resource "helm_release" "loki" {
  count      = var.monitoring_enabled ? 1 : 0
  name       = "loki"
  repository = var.grafana_helm_repository
  chart      = "loki"
  values     = [file("${path.module}/helm/grafana-loki-values-minio.yaml")]
}


###################################################################
# Grafana Monitoring Stack Setup
###################################################################

resource "helm_release" "monitoring" {
  count      = var.monitoring_enabled ? 1 : 0
  name       = "k8s"
  repository = var.grafana_helm_repository
  chart      = "k8s-monitoring"
  values = [
    templatefile("${path.module}/helm/grafana-monitoring-stack.yaml", {
      GKE_CLUSTER_NAME = var.gke_cluster_name
    })
  ]

  depends_on = [helm_release.dashboard]

}
