resource "google_compute_subnetwork" "management_subnet" {
  name          = "${var.prefix}-management-subnet"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = "${var.managed-subnet-ip-cidr}"
  private_ip_google_access = true
}


resource "google_compute_subnetwork" "restricted_subnet" {
  name          = "${var.prefix}-restricted-subnet"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = "${var.restricted-subnet-ip-cidr}"
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = "10.3.0.0/16"
  }

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.4.0.0/20"
  }
  
}