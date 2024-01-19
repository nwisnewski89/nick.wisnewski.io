# output "kubernetes_config" {
#   sensitive   = true
#   description = "The kubernetes provider configuration for the GKE cluster"
#   value       = {
#     host                   = "https://${module.gke.endpoint}"
#     token                  = data.google_client_config.default.access_token
#     cluster_ca_certificate = base64decode(module.gke.ca_certificate)
#   }
# }
