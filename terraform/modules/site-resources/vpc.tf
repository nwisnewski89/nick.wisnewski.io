locals {
  subnet = {
    name       = "${var.name}-k8s-subnet-${var.environment}"
    cidr_range = var.subnetwork_cidr
  }
  pods_ip_ranges = {
    name       = "${var.name}-k8s-pod-ips-${var.environment}"
    cidr_range = var.pods_cidr
  }
  services_ip_ranges = {
    name       = "${var.name}-k8s-service-ips-${var.environment}"
    cidr_range = var.services_cidr
  }
  ingress_tag = "${var.name}-site-ingress-${var.environment}"
  ssh_tag = "${var.name}-ssh-${var.environment}"
}

module "k8s-network" {
  source       = "terraform-google-modules/network/google"
  version      = "9.0.0"
  project_id   = var.project_id
  network_name = "${var.name}-k8s-network-${var.environment}"

  subnets = [
    {
      subnet_name           = local.subnet.name
      subnet_ip             = local.subnet.cidr_range
      subnet_region         = var.region
      subnet_private_access = true
    },
  ]

  secondary_ranges = {
    "${local.subnet.name}" = [
      {
        ip_cidr_range = local.pods_ip_ranges.cidr_range
        range_name    = local.pods_ip_ranges.name
      },
      {
        ip_cidr_range = local.services_ip_ranges.cidr_range
        range_name    = local.services_ip_ranges.name
      },
    ]
  }

  ingress_rules = [
    {
      name          = local.ingress_tag
      source_ranges = ["0.0.0.0/0"]
      target_tags   = [local.ingress_tag]
      allow = [
        {
          protocol = "tcp"
          ports    = ["80", "443"]
        }
      ]
    },
    {
      name          = local.ssh_tag
      source_ranges = ["35.235.240.0/20"]
      target_tags   = [local.ssh_tag]
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
    }
  ]
}

resource "google_compute_router" "k8s-router" {
  name    = "${var.name}-k8s-nat-router-${var.environment}"
  region  = var.region
  project = var.project_id
  network = module.k8s-network.network_id
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "k8s-nat" {
  name                               = "${var.name}-k8s-nat-gateway-${var.environment}"
  project                            = var.project_id
  router                             = google_compute_router.k8s-router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = module.k8s-network.subnets_self_links[0]
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
  log_config {
    filter = "ERRORS_ONLY"
    enable = true
  }

  icmp_idle_timeout_sec            = 30
  tcp_established_idle_timeout_sec = 1200
  tcp_transitory_idle_timeout_sec  = 30
  udp_idle_timeout_sec             = 30
}

resource "google_compute_address" "static-ingress" {
  name     = "${var.name}-k8s-static-ingress-ip-${var.environment}"
  project  = var.project_id
  region   = var.region
  provider = google-beta

  labels = {
    kubeip = "k8s-static-ingress-ip"
  }
}