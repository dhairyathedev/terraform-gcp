terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.25.0"
    }
  }
}

provider "google" {
  project = "sandbox-learning-491602"
  region  = "asia-south1"
}

resource "google_compute_network" "my_vpc" {
  name                    = "my-custom-vpc"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "subnet_a" {
  name          = "my-subnet-a"
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-south1"
  network       = google_compute_network.my_vpc.id
}

resource "google_compute_subnetwork" "subnet_b" {
  name          = "my-subnet-b"
  ip_cidr_range = "10.0.2.0/24"
  region        = "asia-south1"
  network       = google_compute_network.my_vpc.id
}

resource "google_compute_route" "custom_route" {
  name             = "my-custom-internet-route"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.my_vpc.name
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000

  tags = ["egress-internet"]
}


resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh-rule"
  network = google_compute_network.my_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["allow-ssh"]
}

resource "google_compute_firewall" "allow_web" {
  name    = "my-allow-web-rule"
  network = google_compute_network.my_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}
