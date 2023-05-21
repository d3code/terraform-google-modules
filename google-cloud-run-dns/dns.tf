resource "google_cloud_run_domain_mapping" "mapping" {
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
  mapping_dns_records_map = {
    for record in google_cloud_run_domain_mapping.mapping.status[0].resource_records :
    record.type => [record.rrdata]...
  }
   mapping_dns_records_map_flat = {
    for key, records in local.mapping_dns_records_map : key => flatten([for r in records : r[0]])
  }
}

resource "google_dns_record_set" "record" {
  for_each     = local.mapping_dns_records_map_flat
  managed_zone = data.google_dns_managed_zone.zone.name

  name    = "${google_cloud_run_domain_mapping.mapping.name}."
  type    = each.key
  ttl     = 3600
  rrdatas = each.value
}
