resource "google_compute_instance" "private_vm" {
  name         = "${var.prefix}-private-vm"
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = ["${var.prefix}-private-vm"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.management_subnet.id
    # No access_config => No external IP => VM is private
  }
}