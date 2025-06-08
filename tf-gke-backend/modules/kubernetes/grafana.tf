###################################################################
# Grafana Dashboard Setup
###################################################################

resource "helm_release" "dashboard" {
  name       = var.grafana_helm_chart_name
  namespace  = var.monitoring_namespace
  repository = var.grafana_helm_repository
  chart      = var.grafana_helm_chart_name
  timeout    = var.helm_timeout
  values = [
    templatefile("${path.module}/helm/grafana-dashboard-values.yaml", {
      GRAFANA_ADMIN_USER     = var.grafana_admin_user
      GRAFANA_ADMIN_PASSWORD = var.grafana_admin_password
      MONITORING_NAMESPACE   = var.monitoring_namespace
      LOKI_CHART_NAME        = var.loki_chart_name
      PROMETHEUS_CHART_NAME  = var.prometheus_chart_name
    })
  ]
}




###################################################################
# Grafana Loki Logging Setup
###################################################################

resource "kubernetes_secret" "loki_gcp_sa" {
  metadata {
    name      = "loki-secrets"
    namespace = var.monitoring_namespace

  }
  data = {
    "gcp_service_account.json" = base64decode(google_service_account_key.loki_key.private_key)
  }
  type       = "Opaque"
  depends_on = [helm_release.dashboard]

}

resource "helm_release" "loki" {
  name       = var.loki_chart_name
  namespace  = var.monitoring_namespace
  repository = var.grafana_helm_repository
  timeout    = var.helm_timeout
  chart      = var.loki_chart_name
  values     = [file("${path.module}/helm/grafana-loki-values-minio.yaml")]
}


###################################################################
# Grafana Monitoring Stack Setup
###################################################################

resource "helm_release" "monitoring" {
  name       = "k8s"
  namespace  = var.monitoring_namespace
  repository = var.grafana_helm_repository
  timeout    = var.helm_timeout
  chart      = var.grafana_monitoring_stack_chart_name
  values = [
    templatefile("${path.module}/helm/grafana-monitoring-stack.yaml", {
      GKE_CLUSTER_NAME      = var.gke_cluster_name
      LOKI_CHART_NAME       = var.loki_chart_name
      MONITORING_NAMESPACE  = var.monitoring_namespace
      APPLICATION_NAMESPACE = var.application_namespace
    })
  ]
  depends_on = [helm_release.dashboard]

}
