resource "google_compute_router" "router" {
  name    = "${var.prefix}-router"
  region  = var.region
  network = google_compute_network.vpc.id
}