resource "google_compute_router_nat" "nat" {
  name   = "${var.prefix}-nat"
  router = google_compute_router.router.name
  region = var.region

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "AUTO_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.management_subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"] # NAT all traffic
  }
}