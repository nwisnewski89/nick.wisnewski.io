locals {
  subnet = {
    name       = "${var.name}-k8s-subnet-${var.environment}"
    cidr_range = var.subnetwork_cidr
  }
  pods_ip_range = {
    name       = "${var.name}-k8s-pod-ips-${var.environment}"
    cidr_range = var.pods_cidr
  }
  services_ip_range = {
    name       = "${var.name}-k8s-service-ips-${var.environment}"
    cidr_range = var.services_cidr
  }
  ingress_tag = "${var.name}-site-ingress-${var.environment}"
  ssh_tag     = "${var.name}-ssh-${var.environment}"
}

resource "google_compute_network" "k8s_network" {
  name                    = "${var.name}-k8s-network-${var.environment}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "k8s_subnet" {
  name                     = local.subnet.name
  network                  = google_compute_network.k8s_network.id
  region                   = var.region
  ip_cidr_range            = local.subnet.cidr_range
  stack_type               = "IPV4_ONLY"
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = local.services_ip_range.name
    ip_cidr_range = local.services_ip_range.cidr_range
  }

  secondary_ip_range {
    range_name    = local.pods_ip_range.name
    ip_cidr_range = local.pods_ip_range.cidr_range
  }
}

resource "google_compute_firewall" "ingress" {
  name      = local.ingress_tag
  network   = google_compute_network.k8s_network.name
  direction = "INGRESS"


  allow {
    protocol = "tcp"
    ports    = ["443", "80"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = [
    local.ingress_tag
  ]
}

resource "google_compute_firewall" "console_ssh" {
  name      = local.ssh_tag
  network   = google_compute_network.k8s_network.name
  direction = "INGRESS"


  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]

  target_tags = [
    local.ssh_tag
  ]
}


resource "google_compute_address" "static_ingress" {
  provider     = google-beta
  name         = "${var.name}-k8s-static-ingress-ip-${var.environment}"
  project      = var.project_id
  region       = var.region
  address_type = "EXTERNAL"

  labels = {
    kubeip      = local.ingress_tag
    environment = var.environment
  }
}