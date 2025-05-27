# Create the GKE Service Account
resource "google_service_account" "gke_node_sa" {
  account_id   = "${var.prefix}-gke-node-sa"
  display_name = "Custom Service Account for GKE Nodes Using Terraform"
}

# Assign IAM Roles to the Service Account
resource "google_project_iam_member" "gke_node_sa_permissions" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/artifactregistry.reader",
    "roles/container.developer"
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gke_node_sa.email}"
}

# Generate the Service Account Key
resource "google_service_account_key" "gke_node_sa_key" {
  service_account_id = google_service_account.gke_node_sa.name
  private_key_type   = "TYPE_GOOGLE_CREDENTIALS_FILE"

  keepers = {
    timestamp = timestamp()
  }
}

# Save the Key Locally
resource "local_file" "gke_node_sa_key_file" {
  content  = base64decode(google_service_account_key.gke_node_sa_key.private_key)
  filename = "${path.module}/${var.prefix}-gke-node-sa-key.json"
}
