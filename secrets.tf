resource "kubernetes_secret" "ingress-certs" {
  metadata {
    name      = "ingress-certs"
    namespace = var.dev_cluster_namespace
  }

  data = {
    "tls.crt" = file("${path.module}/certificate/fullchain.pem")
    "tls.key" = file("${path.module}/certificate/privkey.pem")
  }

  type = "Opaque"
}
