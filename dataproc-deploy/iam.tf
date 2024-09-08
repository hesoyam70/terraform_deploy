resource "google_service_account" "dataproc-svc" {
  project      = var.project_id
  account_id   = "${var.prefix}-dataproc-svc"
  display_name = "Service Account - dataproc"
}

resource "google_project_iam_member" "svc-access" {
  depends_on = [google_service_account.dataproc-svc]
  project    = var.project_id
  role       = "roles/dataproc.worker"
  member     = "serviceAccount:${google_service_account.dataproc-svc.email}"
}

resource "google_storage_bucket_iam_member" "dataproc-member" {
  depends_on = [google_service_account.dataproc-svc]
  bucket     = google_storage_bucket.dataproc-bucket.name
  role       = "roles/storage.admin"
  member     = "serviceAccount:${google_service_account.dataproc-svc.email}"
}