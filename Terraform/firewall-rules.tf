resource "google_compute_firewall" "iap_ssh" {
  name          = "${var.prefix}-allow-iap-ssh"
  network       =  google_compute_network.vpc.id
  source_ranges = ["35.235.240.0/20"]  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["${var.prefix}-private-vm"]  
}

# Enable the GKE control plane (master) to securely communicate with nodes ( tagged nagham-gke-node ) with over port 443.
resource "google_compute_firewall" "gke_master_access" {
  name          = "${var.prefix}-allow-gke-master-access"
  network       = google_compute_network.vpc.id
  source_ranges = [google_compute_subnetwork.management_subnet.ip_cidr_range]
  allow {
    protocol = "tcp"
    ports    = ["443"]  
  }
  target_tags = ["${var.prefix}-gke-node"]  
}

# Enable HTTP (port 80) ingress to the GKE nodes
resource "google_compute_firewall" "allow_gke_ingress_http" {
  name    = "${var.prefix}-allow-gke-ingress-http"
  network       = google_compute_network.vpc.id

  # Allow traffic from anywhere on TCP port 80
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  direction = "INGRESS"
  priority  = 1000

  target_tags = ["${var.prefix}-gke-node"] 

}
