output "cloud_run_url" {
  description = "Cloud Run application URL"
  value       = google_cloud_run_v2_service.app.uri
}

output "cloud_run_service_name" {
  description = "Cloud Run service name"
  value       = google_cloud_run_v2_service.app.name
}

output "artifact_registry_repository" {
  description = "Artifact Registry repository ID"
  value       = google_artifact_registry_repository.app.repository_id
}

output "github_actions_service_account" {
  description = "GitHub Actions service account"
  value       = google_service_account.github_actions.email
}

output "cloud_sql_private_ip" {
  description = "Cloud SQL private IP"
  value       = google_sql_database_instance.postgres.private_ip_address
  sensitive   = true
}
