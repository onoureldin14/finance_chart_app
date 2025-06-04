resource "kubernetes_namespace" "streamlit" {
  metadata {
    name = "prod"
  }
}

resource "kubernetes_deployment" "streamlit" {
  metadata {
    name      = var.name
    namespace = kubernetes_namespace.streamlit.id
    labels = {
      app = var.name
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }
      }

      spec {
        container {
          name  = var.name
          image = var.docker_image_id
          port {
            container_port = 8501
          }
          resources {
            requests = {
              cpu    = "100m" # 0.1 vCPU
              memory = "128Mi"
            }
            limits = {
              cpu    = "200m" # 0.2 vCPU
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "streamlit" {
  metadata {
    name      = "streamlit-service"
    namespace = kubernetes_namespace.streamlit.id
  }

  spec {
    selector = {
      app = var.name
    }

    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 8501
    }
  }
  depends_on = [kubernetes_deployment.streamlit]
}
