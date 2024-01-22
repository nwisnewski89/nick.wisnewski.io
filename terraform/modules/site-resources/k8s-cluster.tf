locals {
  oauth_scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/service.management",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
  ]
  ingress_pool = "${var.name}-ingress-pool-${var.environment}"
  app_pool     = "${var.name}-app-pool-${var.environment}"
}

resource "google_artifact_registry_repository" "docker" {
  location      = var.region
  repository_id = var.name
  format        = "DOCKER"
}

data "google_client_config" "default" {}

resource "google_container_cluster" "k8s" {
  name               = "${var.name}-k8s-cluster-${var.environment}"
  project            = var.project_id
  location           = var.zone
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = module.k8s-network.network_self_link
  subnetwork = module.k8s-network.subnets_self_links[0]

  private_cluster_config {
    master_ipv4_cidr_block  = var.master_cidr
    enable_private_nodes    = true
    enable_private_endpoint = false
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = local.pods_ip_ranges.name
    services_secondary_range_name = local.services_ip_ranges.name
  }
}

resource "google_container_node_pool" "ingress_pool" {
  name               = local.ingress_pool
  project            = var.project_id
  location           = var.zone
  cluster            = google_container_cluster.k8s.id
  initial_node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type    = "e2-micro"
    disk_size_gb    = 10
    disk_type       = "pd-standard"
    image_type      = "UBUNTU_CONTAINERD"
    preemptible     = false
    service_account = google_service_account.k8s.email
    oauth_scopes    = local.oauth_scopes

    tags = [
      local.ingress_tag,
      local.ssh_tag
    ]

    taint {
      key    = local.ingress_pool
      value  = true
      effect = "NO_EXECUTE"
    }
  }
}

resource "google_container_node_pool" "app_pool" {
  name               = local.app_pool
  project            = var.project_id
  location           = var.zone
  cluster            = google_container_cluster.k8s.id
  initial_node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 1
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type    = "e2-medium"
    disk_size_gb    = 20
    disk_type       = "pd-standard"
    image_type      = "UBUNTU_CONTAINERD"
    preemptible     = true
    service_account = google_service_account.k8s.email
    oauth_scopes    = local.oauth_scopes

    tags = [
      local.ssh_tag
    ]
  }
}