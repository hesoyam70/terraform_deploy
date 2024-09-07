variable "project_id" {
  type        = string
  description = "ID of the Google Project"
}
variable "region" {
  type        = string
  description = "Default Region"
  default     = "us-central1"
}
variable "zone" {
  type        = string
  description = "Default Zone"
  default     = "us-central1-a"
}
variable "server_name" {
  type        = string
  description = "Name of server"
}
#For Google Cloud, there are two main public module repositories.
#The official Terraform Registry at https://registry.terraform.io/browse/modules?provider=google
#Terraform blueprints for Google Cloud at https://cloud.google.com/docs/terraform/blueprints/terraform-blueprints.