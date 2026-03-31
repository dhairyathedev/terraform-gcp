# 8. Create a Compute Engine Instance (VM)
resource "google_compute_instance" "test_vm" {
  name         = "my-test-vm"
  machine_type = "e2-micro"      
  zone         = "asia-south1-a"   
  tags = ["allow-ssh", "web-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.my_vpc.id
    subnetwork = google_compute_subnetwork.subnet_a.id

    access_config {
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    echo "<html><body><h1>Hello from your custom GCP VPC!</h1></body></html>" > /var/www/html/index.html
    systemctl restart apache2
  EOF
}

output "vm_public_ip" {
  value       = google_compute_instance.test_vm.network_interface[0].access_config[0].nat_ip
  description = "The public IP address of the test VM"
}
