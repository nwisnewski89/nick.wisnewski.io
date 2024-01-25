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

variable "name" {
  description = "Name to apply to resources"
  type        = string
  default     = "wisnewski"
}

variable "site_image" {
  description = "The name of the site image"
  type        = string
  default     = "nick-wisnewski-io"
}

variable "ingress_server_image" {
  description = "The name of the ingress server image"
  type        = string
  default     = "ingress-server"
}

data "terraform_remote_state" "site_resources" {
  backend = "gcs"
  config = {
    bucket = "nick-wisnewski-io-terraform-state"
    prefix = "site-resources"
  }
}

locals {
  namespace = "${var.name}-io"
}

data "google_client_config" "provider" {}