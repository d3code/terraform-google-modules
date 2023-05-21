resource "google_cloud_run_domain_mapping" "www" {
  location = var.location
  name     = var.domain

  metadata {
    namespace = var.project_id
  }

  spec {
    route_name = var.cloud_run_service_name
  }
}

data "google_dns_managed_zone" "zone" {
  name = var.managed_zone_name
}

locals {
  www_dns_records_map = {
    for record in google_cloud_run_domain_mapping.www.status[0].resource_records :
    record.type => [record.rrdata]...
  }
   www_dns_records_map_flat = {
    for key, records in local.www_dns_records_map : key => flatten([for r in records : r[0]])
  }
}

resource "google_dns_record_set" "www" {
  for_each     = local.www_dns_records_map_flat
  managed_zone = data.google_dns_managed_zone.zone.name

  name    = "${google_cloud_run_domain_mapping.www.name}."
  type    = each.key
  ttl     = 3600
  rrdatas = each.value
}
