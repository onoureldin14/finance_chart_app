###################################################################
# Prometheus Setup
###################################################################

resource "helm_release" "prometheus" {
  name       = var.prometheus_chart_name
  repository = var.prometheus_helm_repository
  namespace  = var.monitoring_namespace
  chart      = var.prometheus_chart_name
  timeout    = var.helm_timeout
  values = [
    templatefile("${path.module}/helm/prometheus-values.yaml", {
      APPLICATION_NAME      = var.name
      APPLICATION_NAMESPACE = var.application_namespace
    })
  ]

  depends_on = [kubernetes_service.streamlit]
}
