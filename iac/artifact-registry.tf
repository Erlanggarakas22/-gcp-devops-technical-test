resource "google_artifact_registry_repository" "app" {
  location      = var.region
  repository_id = "${var.app_name}-repository"
  description   = "Docker images for the DevOps technical test"
  format        = "DOCKER"

  depends_on = [
    google_project_service.required
  ]
}
