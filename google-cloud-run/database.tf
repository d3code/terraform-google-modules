data "google_sql_database_instance" "database" {
  name = "cryptoledger-instance"
}

# -----------------------------------------------------

resource "google_sql_user" "user" {
  name     = var.name
  instance = data.google_sql_database_instance.database.name
  host     = "%"
  password = random_password.password.result
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# -----------------------------------------------------

resource "google_secret_manager_secret" "database_password" {
  secret_id = "database-password-${var.name}"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "database_password" {
  secret      = google_secret_manager_secret.database_password.id
  secret_data = google_sql_user.user.password
}
