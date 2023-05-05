data "google_service_account" "service_account" {
  project = data.google_project.project.project_id
  account_id = "service-account"
}
