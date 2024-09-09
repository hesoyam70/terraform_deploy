locals {
  ip_cidr_range = "10.10.10.0/28"
}

resource "google_compute_network" "dataproc_network" {
  name                    = "${var.prefix}-cluster-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "us_east1" {
  depends_on               = [google_compute_network.dataproc_network]
  count                    = 1
  name                     = "${var.prefix}-${count.index}-subnetwork"
  ip_cidr_range            = local.ip_cidr_range
  region                   = var.region
  network                  = google_compute_network.dataproc_network.id
  private_ip_google_access = true
}

resource "google_compute_firewall" "firewall_rules" {
  depends_on = [google_compute_network.dataproc_network]
  name       = "${var.prefix}-dataproc-allow-tcp-udp-icmp-all-ports"
  network    = google_compute_network.dataproc_network.name

  // Allow ping
  allow {
    protocol = "icmp"
  }
  //Allow all TCP ports
  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }
  //Allow all UDP ports
  allow {
    protocol = "udp"
    ports    = ["1-65535"]
  }
  source_ranges = [local.ip_cidr_range]
}