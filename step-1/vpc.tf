# Create a VPC network
resource "google_compute_network" "my_vpc_network" {
    project = var.project_id
    name                    = var.network
    auto_create_subnetworks = false  
    routing_mode            = "GLOBAL"  
    description             = "This is a VPC network"
    mtu                     = 1460 
}

resource "google_compute_subnetwork" "this" {
    depends_on               = [resource.google_compute_network.my_vpc_network]
    project                  = var.project_id
    for_each                 = var.subnets
    network                  = var.network
    name                     = each.key
    region                   = each.value["region"]
    ip_cidr_range            = each.value["ip_cidr_range"]
    private_ip_google_access = "true"
}