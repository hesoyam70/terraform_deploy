### Problem

You wanted to automate the provisioning and managing of clusters with Infrastructure as a Code(IaC) framework.

### Solution

Terraform is an Infrastructure as Code (IaC) tool that allows users to create
and maintain cloud infrastructure using declarative configuration language.

#### Terraform code execution involves

1. init - Initializes a state of resources
2. plan - Run a preview and let you know what 
all changes to be applied on top of the current state of resources.
3. apply - Applies the changes on resources.
4. destroy - Deletes all the resources.

### Problem
You want to create a new virtual private cloud(VPC) network for hosting virtual machines 
and attach firewall rules for allowing communication between the machines.

### Solution
Solution

Create a VPC network
gcloud compute networks create <NETWORK_NAME>\
--subnet-mode auto\
--description "VPC network hosting dataproc resources"

Attach a Firewall rule
gcloud compute firewall-rules create <FIREWALL_NAME> --network dataproctest
--allow [PROTOCOL[:PORT]] --source-ranges <IP_RANGE>

**Discussion
Compute Engines that are part of a Dataproc cluster must reside within a VPC network to communicate with each other and external
resources when necessary. 
The Dataproc service mandates that all VMs in the cluster be able to communicate with each other using
the ICMP, TCP (all ports), and UDP (all ports) protocols.**

The default project network typically has subnets created in the range of 10.128.0.0/9. 
It also includes the ‘default-allow-internal’ firewall rule, permitting communication within this subnet range. 
Table 1-3 (if presented) would illustrate an example of these rules. 
If you are creating a custom network, ensure you establish a rule aligned with Dataproc’s requirements to enable internal communication.

![img.png](img.png)

For custom vpc/subnet use the custom subnet range.	tcp:0-65535,udp:0-65535,icmp

To create a VPC network in auto mode
gcloud compute networks create dataproc-vpc\
--subnet-mode auto\
--description "VPC network hosting dataproc resources"

TIP
Configuring subnet mode as ‘auto’ creates multiple subnets (one for each GCP region). 
This VPC creates subnets in all available regions, allowing you to create a Dataproc cluster in any region.

To prevent the automatic creation of too many(40+) subnets in auto mode, 
we can create subnets in required regions. 

This is a two-step process: first, create a VPC, and then add a subnet to it.

Creating VPC with custom subnet mode, It creates an empty VPC without any subnets.
gcloud compute networks create dataproc-vpc\
--subnet-mode custom\
--description "VPC network hosting dataproc resources"

Creating Subnet in us-east1 region with range of 10.120.0.0/20
gcloud compute networks subnets create dataproc-vpc-us-east1-subnet\
--network=dataproc-vpc\
--region=us-east1\
--range=10.120.0.0/20

TIP
A subnet range refers to the capacity to hold a certain number of IP addresses within that subnet. 
In the case of 10.120.0.0/20, it has a capacity of 256 IP addresses, 
with 254 being usable (excluding the very first 10.120.0.0, which is the network address, and the last 10.120.15.255, 
which is the broadcast address).

To choose a suitable subnet range for the maximum number of hosts on a Dataproc cluster, 
you will need to consider the expected number of hosts and allow room for growth.

Resources in VPC are not reachable until you create a firewall rule to allow communication. 
Attach the firewall rule matching dataproc service requirements

Creating Firewall rule for custom subnet with IP range as 10.120.0.0/20
gcloud compute firewall-rules create dataproc-allow-tcp-udp-icmp-all-ports\
--network dataproc-vpc\
--allow tcp:0-65535,udp:0-65535,icmp\
--source-ranges "10.120.0.0/20"

See Also
Refer to Google Cloud public documentation to learn more about VPC Network and Firewall rules 
https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/network
