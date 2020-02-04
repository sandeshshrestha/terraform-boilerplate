resource "google_compute_global_address" "cluster_ingress_dev" {
  name = "ingress-dev"
}

resource "kubernetes_ingress" "ingress-dev" {
  metadata {
    name      = "ingress-dev"
    namespace = var.dev_cluster_namespace

    annotations = {
      "ingress.kubernetes.io/ssl-redirect"          = true
      "ingress.kubernetes.io/force-ssl-redirect"    = true
      "kubernetes.io/ingress.allow-http"            = true
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.cluster_ingress_dev.name
    }
  }

  spec {

    tls {
      hosts = [
        "example.com",
      ]

      secret_name = "ingress-certs"
    }

    rule {
      host = "example.com"

      http {
        path {
          path = "/*"

          backend {
            service_name = kubernetes_service.website-deployment-service.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}
