module "custom_vpc" {
  source     = "./modules/vpc"
  project_id = var.project_id
  prefix     = var.prefix
  region     = var.region
}

module "bucket" {
  source     = "./modules/storage"
  name       = "dataproc-config"
  project_id = var.project_id
  prefix     = var.prefix
  region     = var.region
}

module "iam" {
  source      = "./modules/iam"
  project_id  = var.project_id
  prefix      = var.prefix
  region      = var.region
  bucket_name = module.bucket.bucket_name
}

#module "cluster_template" {
#  source      = "./modules/dataproc-workflow-template"
#  prefix      = var.prefix
#  region      = var.region
#  svc_email   = module.iam.svc_email_name
#  bucket_name = module.bucket.bucket_name
#  subnet_id   = module.custom_vpc.subnet_id
#}
module "cluster" {
  source      = "./modules/dataproc-cluster"
  prefix      = var.prefix
  region      = var.region
  svc_email   = module.iam.svc_email_name
  bucket_name = module.bucket.bucket_name
  subnet_id   = module.custom_vpc.subnet_id
}
