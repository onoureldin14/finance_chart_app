resource "kubernetes_deployment" "streamlit" {
  metadata {
    name = "streamlit-app"
    labels = {
      app = "streamlit"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "streamlit"
      }
    }

    template {
      metadata {
        labels = {
          app = "streamlit"
        }
      }

      spec {
        container {
          name  = "streamlit"
          image = "europe-west2-docker.pkg.dev/security-vmt/finance-app-repo/stock-viewer:latest"
          port {
            container_port = 8501
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "streamlit" {
  metadata {
    name = "streamlit-service"
  }

  spec {
    selector = {
      app = "streamlit"
    }

    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 8501
    }
  }
}
