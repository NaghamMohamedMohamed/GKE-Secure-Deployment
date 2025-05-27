resource "google_container_cluster" "gke_cluster" {

    name     = "${var.prefix}-private-gke-cluster"
    location = var.region
    initial_node_count = 1

    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.restricted_subnet.id

    deletion_protection = false
    
    private_cluster_config {
        enable_private_nodes    = true
        enable_private_endpoint = true

        master_ipv4_cidr_block = "172.16.0.0/28"
        master_global_access_config {
            enabled = true
        }
    }



    master_authorized_networks_config {
        cidr_blocks {
        cidr_block   = var.managed-subnet-ip-cidr
        display_name = "nagham-authorized-network"
        }
    }

    ip_allocation_policy {
        cluster_secondary_range_name  = google_compute_subnetwork.restricted_subnet.secondary_ip_range[0].range_name
        services_secondary_range_name = google_compute_subnetwork.restricted_subnet.secondary_ip_range[1].range_name
    }

    node_config {
        machine_type = "e2-small"
        oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
        ]
        service_account = google_service_account.gke_node_sa.email
        tags = ["gke-node"]

        # Ensure no external IP ( As it is private cluster )
        shielded_instance_config {
            enable_secure_boot = true
        }
    }

    workload_identity_config {
        workload_pool = "${var.project_id}.svc.id.goog"
    }

    release_channel {
        channel = "REGULAR"
    }

    depends_on = [
        google_project_iam_member.gke_node_sa_permissions ,
        google_project_service.container  # Ensures the API is ready
    ]
}