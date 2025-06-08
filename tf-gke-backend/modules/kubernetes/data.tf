data "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "default"
  }

  depends_on = [helm_release.dashboard]
}


data "kubernetes_service" "prometheus-server" {
  metadata {
    name      = "prometheus-server"
    namespace = "default"
  }
  depends_on = [helm_release.prometheus]
}
