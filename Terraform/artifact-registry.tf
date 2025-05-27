# Create Docker Repository
resource "google_artifact_registry_repository" "docker_repo" {
  depends_on = [google_project_service.artifactregistry]  # Ensures API is ready

  provider  = google
  location  = "us-central1"
  repository_id = "${var.prefix}-docker-repo"
  description   = "Docker repository"
  format        = "DOCKER"
}
