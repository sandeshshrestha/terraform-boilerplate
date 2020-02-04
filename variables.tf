variable "gcp_project" {
  type    = string
}

variable "gcp_region" {
  type    = string
  default = "europe-west1"
}

variable "dev_cluster_namespace" {
  type    = string
  default = "dev"
}

variable "dev_cluster_name" {
  type    = string
  default = "my-cluster"
}

variable "dev_cluster_machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "dev_cluster_image_type" {
  type    = string
  default = "COS"
}

variable "dev_pool_disk_size_gb" {
  type    = number
  default = 10
}

variable "dev_pool_min_node_count" {
  type    = number
  default = 2
}

variable "dev_pool_max_node_count" {
  type    = number
  default = 10
}

variable "dev_cluster_master_auth_username" {
  type    = string
}

variable "dev_cluster_master_auth_password" {
  type    = string
}
