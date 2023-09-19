terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

data "google_billing_account" "account" {
  billing_account = var.billing_account
}

resource "google_project" "project" {
  name            = var.project_id
  project_id      = var.project_id
  org_id          = var.org_id
  billing_account = data.google_billing_account.account.id
}

resource "time_resource" "project_create_wait" {
  depends_on = [google_project.project]
  create_duration = "30s"
}

resource "google_project_service" "service" {
  depends_on = [ time_resource.project_create_wait ]
  project  = google_project.project.project_id
  service  = each.value
  for_each = var.services
}

resource "time_resource" "service_create_wait" {
  depends_on = [google_project_service.service]
  create_duration = "60s"
}
