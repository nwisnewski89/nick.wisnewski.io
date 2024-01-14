resource "google_container_registry" "registry" {
  project  = var.project_id
  location = "US"
}

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version = "24.1.0"
  project_id   = var.project_id
  depends_on   = [module.gke]
  location     = module.gke.location
  cluster_name = module.gke.name
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "kubeconfig-${var.environment}"
}

module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "6.0.0"
  project_id   = var.project_id
  network_name = "${var.network}-${var.environment}"

  subnets = [
    {
      subnet_name   = "${var.subnetwork}-${var.environment}"
      subnet_ip     = "10.40.0.0/16"
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    "${var.subnetwork}-${var.environment}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "10.50.0.0/16"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "10.60.0.0/16"
      },
    ]
  }
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                = "24.1.0"
  project_id             = var.project_id
  name                   = "${var.cluster_name}-${var.environment}"
  regional               = true
  region                 = var.region
  network                = module.gcp-network.network_name
  subnetwork             = module.gcp-network.subnets_names[0]
  ip_range_pods          = var.ip_range_pods_name
  ip_range_services      = var.ip_range_services_name
  
  node_pools = [
    {
      name                      = "node-pool"
      machine_type              = "e2-micro"
      node_locations            = join(",", var.node_locations)
      min_count                 = 1
      max_count                 = 2
      disk_size_gb              = 20
    },
  ]
}