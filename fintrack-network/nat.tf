resource "google_compute_router" "fintrack_router" {
  name    = "fintrack-router"
  region  = var.proj_region
  network = google_compute_network.fintrack_vpc.id
}

resource "google_compute_router_nat" "fintrack_nat" {
  name   = "fintrack-nat"
  router = google_compute_router.fintrack_router.name
  region = var.proj_region

  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.private_backend.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  subnetwork {
    name                    = google_compute_subnetwork.private_gke.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  subnetwork {
    name                    = google_compute_subnetwork.private_database.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  subnetwork {
    name                    = google_compute_subnetwork.private_internal_monitoring.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
