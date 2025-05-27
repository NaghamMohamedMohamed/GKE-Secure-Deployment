provider "google" {
  # credentials = file(var.key_file)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}