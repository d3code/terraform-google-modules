terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

resource "google_project_service" "project" {
  for_each = var.services
  service  = each.value
  project  = var.project
}

variable "project" {
  description = "The project_id of the service account"
  type        = string
}

variable "services" {
  description = "The services to enable for the project"
  type        = set(string)
  default = [
    "iam.googleapis.com",
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "sqladmin.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudtasks.googleapis.com",
  ]
}
