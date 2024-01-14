variable "project_id" {
  description = "The project ID to host the cluster in"
  default     = ""
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "nw-k8s-cluster"
}

variable "environment" {
  description = "The environment for the GKE cluster"
  default     = "prod"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = ""
}

variable "node_locations" {
  description = "The azs of the cluster nodes"
  default     = []
}

variable "network" {
  description = "The VPC network created to host the cluster in"
  default     = "nw-k8s-network"
}

variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
  default     = "nw-k8s-subnet"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "nw-k8s-ip-range-pods"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  default     = "nw-k8s-ip-range-services"
}