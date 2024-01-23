provider "google" {
  region  = var.region
  project = var.project_id
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.site_resources.outputs.k8s_config.host
  token                  = data.terraform_remote_state.site_resources.outputs.k8s_config.token
  cluster_ca_certificate = data.terraform_remote_state.site_resources.outputs.k8s_config.cluster_ca_certificate
}