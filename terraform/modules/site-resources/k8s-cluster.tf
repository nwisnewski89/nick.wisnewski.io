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

resource "google_container_cluster" "k8s" {
  provider           = google-beta
  name               = "${var.name}-k8s-cluster-${var.environment}"
  project            = var.project_id
  location           = var.region
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  remove_default_node_pool = true
  initial_node_count       = 1

  network                  = google_compute_network.k8s_network.id
  subnetwork               = google_compute_subnetwork.k8s_subnet.id
  enable_l4_ilb_subsetting = true

  ip_allocation_policy {
    cluster_secondary_range_name  = local.pods_ip_range.name
    services_secondary_range_name = local.services_ip_range.name
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  node_locations = [var.zone]
}

resource "google_container_node_pool" "ingress_pool" {
  name               = local.ingress_pool
  project            = var.project_id
  location           = google_container_cluster.k8s.location
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
    spot            = true
    service_account = google_service_account.k8s.email
    oauth_scopes    = local.oauth_scopes

    metadata = {
      disable-legacy-endpoints = "true"
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      nodegroup = "ingress"
      kubeip    = "use"
    }

    tags = [
      local.ingress_tag,
      local.ssh_tag
    ]

    resource_labels = {
      environment = var.environment
      kubeip      = "use"
      public      = "true"
    }
  }
}

resource "google_container_node_pool" "site_pool" {
  name               = local.app_pool
  project            = var.project_id
  location           = google_container_cluster.k8s.location
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
    preemptible     = false
    service_account = google_service_account.k8s.email
    oauth_scopes    = local.oauth_scopes

    metadata = {
      disable-legacy-endpoints = "true"
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      nodegroup = "site"
      kubeip    = "ignore"
    }

    resource_labels = {
      environment = var.environment
      kubeip      = "ignore"
      public      = "false"
    }

    tags = [
      local.ssh_tag
    ]
  }

  network_config {
    enable_private_nodes = true
  }
}