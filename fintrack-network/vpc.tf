resource "google_compute_network" "fintrack_vpc" {
  name                    = "fintrack-network"
  routing_mode            = "GLOBAL"
  mtu                     = 1460
  auto_create_subnetworks = false

}

resource "google_compute_subnetwork" "public_a" {
  name          = "public-a"
  ip_cidr_range = "172.16.1.0/24"
  region        = var.proj_region
  network       = google_compute_network.fintrack_vpc.id
}

resource "google_compute_subnetwork" "private_backend" {
  name                     = "private-backend"
  ip_cidr_range            = "172.16.2.0/24"
  region                   = var.proj_region
  network                  = google_compute_network.fintrack_vpc.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private_gke" {
  name                     = "private-gke"
  ip_cidr_range            = "172.16.32.0/20"
  region                   = var.proj_region
  network                  = google_compute_network.fintrack_vpc.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = "10.4.0.0/14"
  }

  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = "10.8.0.0/20"
  }
}

resource "google_compute_subnetwork" "private_database" {
  name                     = "private-database"
  ip_cidr_range            = "172.16.16.0/28"
  region                   = var.proj_region
  network                  = google_compute_network.fintrack_vpc.id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private_internal_monitoring" {
  name                     = "private-internal-monitoring"
  ip_cidr_range            = "172.16.17.0/24"
  region                   = var.proj_region
  network                  = google_compute_network.fintrack_vpc.id
  private_ip_google_access = true
}

