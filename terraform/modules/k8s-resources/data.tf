data "terraform_remote_state" "site_resources" {
  backend = "gcs"
  config = {
    bucket = "nick-wisnewski-io-terraform-state"
    prefix = "site-resources"
  }
}