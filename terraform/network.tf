resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  project = var.project_id
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 2.5.0"

  # Give the network a name and project
  project_id   = google_project_service.compute.project
  network_name = "gke-vpc"

  subnets = [
    {
      # Creates your first subnet and defines a range for it
      subnet_name   = "default-subnet"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    },
    {
      # dedicated subnet for GKE
      subnet_name   = "gke-subnet"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = var.region
    },
  ]

  # Define secondary ranges for each of your subnets
  secondary_ranges = {
    default-subnet = [],

    gke-subnet = [
      {
        # Define a secondary range for Kubernetes pods to use
        range_name    = "my-gke-pods-range"
        ip_cidr_range = "192.168.64.0/24"
      },
      {
        # Define a secondary range for Kubernetes svc to use
        # 264 addr is enought for small cluster
        # in case of big cluster consider to use another netmask
        range_name    = "my-gke-services-range"
        ip_cidr_range = "192.168.65.0/24"
      },
    ]
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]

}
