resource "google_compute_global_address" "private_service_range" {
  name          = "${var.app_name}-${var.environment}-service-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network = google_compute_network.main.id
  service = "servicenetworking.googleapis.com"

  reserved_peering_ranges = [
    google_compute_global_address.private_service_range.name
  ]

  depends_on = [
    google_project_service.required
  ]
}

resource "random_password" "database" {
  length           = 24
  special          = true
  override_special = "_%@"
}

resource "google_sql_database_instance" "postgres" {
  name             = "${var.app_name}-${var.environment}-postgres"
  region           = var.region
  database_version = "POSTGRES_15"

  deletion_protection = false

  settings {
    edition = "ENTERPRISE"

    tier = "db-custom-1-3840"

    availability_type = "ZONAL"

    disk_type       = "PD_SSD"
    disk_size       = 10
    disk_autoresize = true

    backup_configuration {
      enabled = true
    }

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.main.id
      enable_private_path_for_google_cloud_services = true
    }
  }

  depends_on = [
    google_project_service.required,
    google_service_networking_connection.private_vpc_connection
  ]
}

resource "google_sql_database" "app" {
  name     = var.database_name
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "app" {
  name     = var.database_user
  instance = google_sql_database_instance.postgres.name
  password = random_password.database.result
}

resource "google_secret_manager_secret" "database_password" {
  secret_id = "${var.app_name}-${var.environment}-database-password"

  replication {
    auto {}
  }

  depends_on = [
    google_project_service.required
  ]
}

resource "google_secret_manager_secret_version" "database_password" {
  secret      = google_secret_manager_secret.database_password.id
  secret_data = random_password.database.result
}
