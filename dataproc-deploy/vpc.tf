locals {
  ip_cidr_range = "10.10.10.0/27"
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