resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "instance" {
  name             = "dmeo-instance"
  region           = "us-central1"
  database_version = "MYSQL_8_0"
  deletion_protection  = false
  project = var.project_id

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = var.network_self_link
#      enable_private_path_for_google_cloud_services = true
    }

  }
}

#Creating the Database inside the Instance
resource "google_sql_database" "database" {
  name     = "my_db"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "users" {
  name     = "admin"
  instance = google_sql_database_instance.instance.name
  password = "admin"
}