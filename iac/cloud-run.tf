resource "google_cloud_run_v2_service" "app" {
  name     = "${var.app_name}-${var.environment}"
  location = var.region

  deletion_protection = false

  template {
    service_account = google_service_account.cloud_run.email

    scaling {
      min_instance_count = 0
      max_instance_count = 3
    }

    containers {
      image = var.container_image

      ports {
        container_port = 8080
      }

      env {
        name  = "DB_HOST"
        value = google_sql_database_instance.postgres.private_ip_address
      }

      env {
        name  = "DB_PORT"
        value = "5432"
      }

      env {
        name  = "DB_NAME"
        value = google_sql_database.app.name
      }

      env {
        name  = "DB_USER"
        value = google_sql_user.app.name
      }

      env {
        name = "DB_PASSWORD"

        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.database_password.secret_id
            version = "latest"
          }
        }
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }

      startup_probe {
        tcp_socket {
          port = 8080
        }

        initial_delay_seconds = 5
        timeout_seconds       = 5
        period_seconds        = 10
        failure_threshold     = 10
      }
    }

    vpc_access {
      network_interfaces {
        network    = google_compute_network.main.name
        subnetwork = google_compute_subnetwork.private.name
      }

      egress = "PRIVATE_RANGES_ONLY"
    }
  }

  depends_on = [
    google_project_service.required,
    google_sql_database_instance.postgres,
    google_secret_manager_secret_iam_member.cloud_run_secret_accessor
  ]
}

resource "google_cloud_run_v2_service_iam_member" "public" {
  project  = var.project_id
  location = google_cloud_run_v2_service.app.location
  name     = google_cloud_run_v2_service.app.name

  role   = "roles/run.invoker"
  member = "allUsers"
}
