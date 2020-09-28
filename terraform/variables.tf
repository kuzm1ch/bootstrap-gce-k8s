# network related variables
variable "project_id" {
  description = "The project ID to host the network in"
}

variable "network_name" {
  description = "The name of the VPC network being created"
  default     = "k8s"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "us-west1"
}

###

variable "cluster_name_suffix" {
  description = "A suffix to append to the default cluster name"
  default     = ""
}

# 264 addr is enought for small cluster
# in case of big cluster consider to use another netmask
# variable "ip_range_pods" {
#   description = "The secondary ip range to use for pods"
#   default     = "192.168.64.0/24"
# }

# variable "gke_subnetwork" {
#   description = "gke subnet network name"
#   default     = "gke-subnet"
# }

# variable "ip_range_services" {
#   description = "The secondary ip range to use for services"
# }

# variable "compute_engine_service_account" {
#   description = "Service account to associate to the nodes in the cluster"
# }