resource "google_dataproc_cluster" "mycluster" {
  name       = "${var.prefix}-dataproc"
  region     = var.region
#  depends_on = [google_compute_subnetwork.us_east1]

  cluster_config {
    staging_bucket = var.bucket_name

    master_config {
      num_instances = var.dataproc_master_count
      machine_type  = var.dataproc_master_machine_type
      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = var.dataproc_master_bootdisk
      }
    }

    worker_config {
      num_instances = var.dataproc_workers_count
      machine_type  = var.dataproc_worker_machine_type
      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = var.dataproc_worker_bootdisk
        num_local_ssds    = var.worker_local_ssd
      }
    }

    preemptible_worker_config {
      num_instances = var.preemptible_worker
    }

    software_config {
      image_version = "2.0.66-debian10"
    }

    gce_cluster_config {
      zone                   = "${var.region}-b"
      subnetwork             = var.subnet_id
      service_account        = var.svc_email
      service_account_scopes = ["cloud-platform"]
      internal_ip_only = true
    }
  }
}