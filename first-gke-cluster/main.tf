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
	region = "us-central1"
}

resource "google_container_cluster" "primary" {
	name = "my-first-cluster"

	location = "us-central1"

	enable_autopilot = true
	deletion_protection = false
}
