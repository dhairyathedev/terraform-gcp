resource "google_compute_firewall" "allow_http_https" {
  name    = "allow-http-https"
  network = google_compute_network.fintrack_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["load-balancer"]
}

resource "google_compute_firewall" "allow_bastion_host_access" {
  name    = "allow-bastion-host-access"
  network = google_compute_network.fintrack_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion-host"]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.fintrack_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_tags = ["bastion-host"]
  target_tags = ["backend", "monitoring"]
}

resource "google_compute_firewall" "allow_lb_to_backend" {
  name    = "allow-lb-to-backend"
  network = google_compute_network.fintrack_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_tags = ["load-balancer"]
  target_tags = ["backend"]
}

resource "google_compute_firewall" "allow_backend_to_db" {
  name    = "allow-backend-to-db"
  network = google_compute_network.fintrack_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_tags = ["backend"]
  target_tags = ["cloudsql"]
}

resource "google_compute_firewall" "allow_monitoring" {
  name    = "allow-monitoring"
  network = google_compute_network.fintrack_vpc.id

  allow {
    protocol = "tcp"
    ports    = ["9090"]
  }

  source_tags = ["monitoring"]
  target_tags = ["backend", "gke"]
}

resource "google_compute_firewall" "deny_all_ingress" {
  name    = "deny-all-ingress"
  network = google_compute_network.fintrack_vpc.id

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
  priority      = 65534
}
