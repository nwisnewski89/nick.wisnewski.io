variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "environment" {
  description = "The environment for the GKE cluster"
  type        = string
  default     = "prod"
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default     = ""
}

variable "zone" {
  description = "The zone where the cluster is hosted"
  type        = string
  default     = ""
}

variable "subnetwork_cidr" {
  description = "Cidr range for the subnetwork"
  type        = string
}

variable "pods_cidr" {
  description = "The secondary ip range to use for pods"
  type        = string
}

variable "services_cidr" {
  description = "The secondary ip range to use for services"
  type        = string
}

variable "name" {
  description = "Name to apply to resources"
  type        = string
  default     = "wisnewski"
}

data "google_client_config" "provider" {}