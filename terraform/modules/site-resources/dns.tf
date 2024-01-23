resource "google_dns_managed_zone" "dns_zone" {
  name     = var.name
  dns_name = "${var.name}.io."
}

resource "google_dns_record_set" "site" {
  name = "nick.${google_dns_managed_zone.dns_zone.dns_name}"
  type = "A"
  ttl  = 60

  managed_zone = google_dns_managed_zone.dns_zone.name

  rrdatas = [google_compute_address.static_ingress.address]
}