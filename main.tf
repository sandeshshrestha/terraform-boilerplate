provider "google" {
  credentials = file("${path.module}/gcloud-service.json")
  project     = var.gcp_project
  region      = var.gcp_region
}

resource "google_container_cluster" "dev" {
  name     = var.dev_cluster_name
  location = var.gcp_region

  remove_default_node_pool = true
  enable_legacy_abac       = true
  initial_node_count       = 1

  master_auth {
    username = var.dev_cluster_master_auth_username
    password = var.dev_cluster_master_auth_password
  }
}

resource "google_container_node_pool" "dev_np" {
  name       = "my-node-pool"
  location   = var.gcp_region
  cluster    = google_container_cluster.dev.name
  node_count = 1

  autoscaling {
    min_node_count = var.dev_pool_min_node_count
    max_node_count = var.dev_pool_max_node_count
  }

  node_config {
    machine_type = var.dev_cluster_machine_type
    image_type   = var.dev_cluster_image_type
    disk_size_gb = var.dev_pool_disk_size_gb

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/pubsub",
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

provider "kubernetes" {
  host     = google_container_cluster.dev.endpoint
  username = var.dev_cluster_master_auth_username
  password = var.dev_cluster_master_auth_password

  client_certificate     = base64decode(google_container_cluster.dev.master_auth.0.client_certificate)
  client_key             = base64decode(google_container_cluster.dev.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.dev.master_auth.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "dev" {
  metadata {
    annotations = {
      name = "dev-annotation"
    }

    name = "dev"
  }
}

output "dev_k8s_client_certificate" {
  value = google_container_cluster.dev.master_auth.0.client_certificate
}

output "dev_k8s_client_key" {
  value = google_container_cluster.dev.master_auth.0.client_key
}

output "dev_k8s_cluster_ca_certificate" {
  value = google_container_cluster.dev.master_auth.0.cluster_ca_certificate
}

output "cluster_ip" {
  value = google_container_cluster.dev.endpoint
}

output "public_ip" {
  value = google_compute_global_address.cluster_ingress_dev.address
}
