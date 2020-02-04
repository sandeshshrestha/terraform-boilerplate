resource "kubernetes_service" "website-deployment-service" {
  metadata {
    name      = "website-deployment-service"
    namespace = var.dev_cluster_namespace
  }

  spec {
    selector = {
      test = "website"
    }

    port {
      name        = "http"
      port        = 80
      protocol    = "TCP"
      target_port = 80
    }

    type = "NodePort"
  }
}

resource "kubernetes_deployment" "website-deployment" {
  metadata {
    name      = "website-deployment"
    namespace = var.dev_cluster_namespace
    labels = {
      test = "website"
    }
  }

  spec {

    selector {
      match_labels = {
        test = "website"
      }
    }

    template {
      metadata {
        labels = {
          test = "website"
        }
      }

      spec {
        container {
          name              = "website"
          image             = "nginx:latest"
          image_pull_policy = "Always"

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 3
            timeout_seconds       = 3
          }
          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "website-deployment-autoscaler" {
  metadata {
    name = "website-deployment-autoscaler"
    namespace = var.dev_cluster_namespace
  }
  spec {
    max_replicas = 11
    min_replicas = 2
    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.website-deployment.metadata.0.name
    }
    target_cpu_utilization_percentage = 80
  }
}
