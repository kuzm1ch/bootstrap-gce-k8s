locals {
  cluster_type = "simple-regional-private"
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
  project = var.project_id
  depends_on = [google_project_service.compute]
}


module "gke" {
  source                    = "terraform-google-modules/kubernetes-engine/google"
  version                   = "~> v11.1.0"
  project_id                = google_project_service.container.project
  name                      = "${local.cluster_type}-cluster${var.cluster_name_suffix}"
  regional                  = true
  region                    = var.region
  network                   = module.vpc.network_name
  subnetwork                = module.vpc.subnets_names[1]
  ip_range_pods             = "my-gke-pods-range"
  ip_range_services         = "my-gke-services-range"
  create_service_account    = true
  default_max_pods_per_node = 20
  remove_default_node_pool  = true

  node_pools = [
    {
      name              = "pool-01"
      min_count         = 1
      max_count         = 100
      local_ssd_count   = 0
      disk_size_gb      = 100
      disk_type         = "pd-standard"
      image_type        = "COS"
      auto_repair       = true
      auto_upgrade      = true
      preemptible       = false
      max_pods_per_node = 20
    },
  ]
}

data "google_client_config" "default" {
}
