resource "google_cloud_run_v2_service" "default" {
  name     = var.name
  project  = data.google_project.project.project_id
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = data.google_service_account.service_account.email

    annotations = {
      x_d3code_sql_connection_name = data.google_sql_database_instance.database.connection_name
      x_d3code_commit              = var.commit
    }

    labels = {
      x_d3code_commit              = var.commit
    }

    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [data.google_sql_database_instance.database.connection_name]
      }
    }

    containers {
      image = "${var.image}:${var.commit}"

      ports {
        container_port = var.port
      }

      startup_probe {
        initial_delay_seconds = 2
        timeout_seconds       = 60
        period_seconds        = 5

        tcp_socket {
          port = var.port
        }
      }

      env {
        name  = "DATABASE_CONNECTION"
        value = "/cloudsql/${data.google_sql_database_instance.database.connection_name}"
      }

      env {
        name  = "DATABASE_SCHEMA"
        value = "cryptoledger"
      }

      env {
        name  = "DATABASE_USER"
        value = google_sql_user.user.name
      }

      env {
        name = "DATABASE_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.database_password.secret_id
            version = google_secret_manager_secret_version.database_password.version
          }
        }
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

# -----------------------------------------------------

data "google_iam_policy" "no-auth" {
  binding {
    role    = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_v2_service_iam_policy" "no-auth" {
  name        = google_cloud_run_v2_service.default.name
  location    = google_cloud_run_v2_service.default.location
  project     = google_cloud_run_v2_service.default.project
  policy_data = data.google_iam_policy.no-auth.policy_data
}

resource "google_cloud_run_domain_mapping" "api" {
  location = google_cloud_run_v2_service.default.location
  name     = "api.cryptoledger.com.au"

  metadata {
    namespace = var.project
  }

  spec {
    route_name = google_cloud_run_v2_service.default.name
  }
}
