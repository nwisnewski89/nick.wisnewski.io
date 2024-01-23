terraform {
  backend "gcs" {
    bucket = "nick-wisnewski-io-terraform-state"
    prefix = "k8s-resources"
  }
}