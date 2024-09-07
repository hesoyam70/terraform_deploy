data "google_compute_zones" "available" {
}

resource "google_compute_instance" "this" {
  count        = var.instance_number
  name         = "server-data-source-${count.index}"
  machine_type = var.machine_type
  zone         = data.google_compute_zones.available.names[count.index % length(data.google_compute_zones.available.names)]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = var.network_name
    access_config {

    }
  }
}