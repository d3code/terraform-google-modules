variable "project_id" {
  description = "The project_id of the project"
  type        = string
}

variable "location" {
  type    = string
}

variable "domain" {
  type    = string
}

variable "managed_zone_name" {
  type    = string
}

variable "cloud_run_service_name" {
  description = "Google Cloud Run v2 Service Name [ google_cloud_run_v2_service.<service>.name ]"
  type    = string
}
