output "k8s_config" {
  value = {
    host                   = "https://${google_container_cluster.k8s.endpoint}"
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.k8s.master_auth[0].cluster_ca_certificate)
  }
  sensitive   = true
  description = "Configuration for k8s provider"
}

output "kubeip_filter" {
  value       = "labels.kubeip=${local.ingress_tag};labels.environment=${var.environment}"
  description = "The filter for kubeip sepc to locat static ips"
}

output "kubeip_service_account" {
  value       = google_service_account.kubeip.email
  description = "The service account to use for kubeip GKE workload identity binding"
}

output "ingress_pool" {
  value       = google_container_node_pool.ingress_pool.name
  description = "The ingress pool name"
}

output "site_pool" {
  value       = google_container_node_pool.site_pool.name
  description = "The site pool name"
}

output "cluster_name" {
  value       = google_container_cluster.k8s.name
  description = "The clustername name"
}