terraform {
  backend "gcs" {
    bucket = "tf-storage-stack"
  }
}