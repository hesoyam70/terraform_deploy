resource "google_storage_bucket" "dataproc-bucket" {
  project                     = var.project_id
  name                        = "${var.prefix}-${var.name}"
  uniform_bucket_level_access = true
  location                    = var.region
  force_destroy = true
}