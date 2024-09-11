resource "google_dataproc_workflow_template" "template" {
  name = "template-example"
  location = var.region
  placement {
    managed_cluster {
      cluster_name = "my-cluster"
      config {
        gce_cluster_config {
          zone                   = "${var.region}-b"
          subnetwork             = var.subnet_id##
          service_account        = var.svc_email##
        }
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

        secondary_worker_config {
          num_instances = 2
        }
        software_config {
          image_version = "2.0.35-debian10"
        }
      }
    }
  }
  jobs {
    step_id = "test-job"
    pyspark_job {
      main_python_file_uri = "gs://temp-scripts-spark/firstjob.py"
    }
  }
}