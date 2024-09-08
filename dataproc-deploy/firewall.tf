resource "google_compute_firewall" "firewall_rules" {
  name    = "${var.prefix}-cluster-firewall-rules"
  network = google_compute_network.dataproc_network.name

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
  source_ranges = ["0.0.0.0/0"]
}