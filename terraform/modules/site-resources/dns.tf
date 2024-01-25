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

resource "google_dns_record_set" "www_site" {
  name = "www.nick.${google_dns_managed_zone.dns_zone.dns_name}"
  type = "A"
  ttl  = 60

  managed_zone = google_dns_managed_zone.dns_zone.name

  rrdatas = [google_compute_address.static_ingress.address]
}

#Email Server records
resource "google_dns_record_set" "txt_record" {
  name = google_dns_managed_zone.dns_zone.dns_name
  type = "TXT"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns_zone.name

  rrdatas = [
    "MS=ms86065626",
    "\"v=spf1 include:secureserver.net -all\"",
  ]
}

resource "google_dns_record_set" "autodiscover" {
  name = "autodiscover.${google_dns_managed_zone.dns_zone.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns_zone.name

  rrdatas = ["autodiscover.outlook.com."]
}

resource "google_dns_record_set" "email" {
  name = "email.${google_dns_managed_zone.dns_zone.dns_name}"
  type = "CNAME"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns_zone.name

  rrdatas = ["email.secureserver.net."]
}

resource "google_dns_record_set" "mx" {
  name = google_dns_managed_zone.dns_zone.dns_name
  type = "MX"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns_zone.name

  rrdatas = ["0 wisnewski-io.mail.protection.outlook.com."]
}