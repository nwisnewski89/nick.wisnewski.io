output "kubernetes_config" {
  sensitive   = true
  description = "The kubernetes provider configuration for the GKE cluster"
  value       = {
    host                   = "https://${google_container_cluster.k8s.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.k8s.master_auth.0.cluster_ca_certificate)
  }
}

output "kubeip" {
  description = "The id of the kube ip service account"
  value       = google_service_account.kubeip.account_id
}

output "app_pool" {
  description = "App pool name"
  value       = google_container_node_pool.app_pool.name
}

output "ingress_pool" {
  description = "Ingress pool name"
  value       = google_container_node_pool.ingress_pool.name
}

output "static_ingress" {
  description = "Static ingress ip name"
  value = google_compute_address.static-ingress.name
}