data "google_client_config" "provider" {}

data "google_container_cluster" "my_cluster" {
  name     = module.gke.name
  location = module.gke.region
  project  = var.project_id
}

provider "helm" {
    kubernetes {
        load_config_file = false
        host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
        token = data.google_client_config.provider.access_token
        cluster_ca_certificate = base64decode(
        data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
        )
    }
}

resource "helm_release" "argocd" {
    name        = "argo-cd"
    repository  = "https://argoproj.github.io/argo-helm"
    chart       = "argo-cd"
    create_namespace = true
    namespace   = "argocd"

  set {
    name  = "installCRDs"
    value = "false"
  }

}


resource "helm_release" "apps" {
  name       = "argocd-apps"
  chart      = "../argocd/argocd-apps"
  namespace  = "argocd"
  depends_on = [helm_release.argocd]
}
