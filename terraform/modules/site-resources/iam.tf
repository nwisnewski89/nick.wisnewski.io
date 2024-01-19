resource "google_project_iam_custom_role" "k8s-role" {
  role_id = "k8srole"
  title   = "k8s Cluster Role"

  project    = var.project_id

  permissions = [
    "compute.addresses.list",
    "compute.instances.addAccessConfig",
    "compute.instances.deleteAccessConfig",
    "compute.instances.get",
    "compute.instances.list",
    "compute.projects.get",
    "container.clusters.get",
    "container.clusters.list",
    "resourcemanager.projects.get",
    "compute.networks.useExternalIp",
    "compute.subnetworks.useExternalIp",
    "compute.addresses.use",
    "resourcemanager.projects.get",
    "storage.objects.get",
    "storage.objects.list",
  ]
}

resource "google_service_account" "k8s-service-account" {
  account_id = "k8sserviceaccount"
  project    = var.project_id
}

resource "google_project_iam_member" "k8s-role-member" {
  role       = google_project_iam_custom_role.k8s-role.id
  project    = var.project_id
  member     = google_service_account.k8s-service-account.member
}

resource "google_project_iam_custom_role" "kubeip" {
  role_id = "kubeip"
  title   = "kubeip Role"

  project    = var.project_id

  permissions = [
    "compute.addresses.list",
    "compute.instances.addAccessConfig",
    "compute.instances.deleteAccessConfig",
    "compute.instances.get",
    "compute.instances.list",
    "compute.projects.get",
    "container.clusters.get",
    "container.clusters.list",
    "resourcemanager.projects.get",
    "compute.networks.useExternalIp",
    "compute.subnetworks.useExternalIp",
    "compute.addresses.use",
  ]
}

resource "google_service_account" "kubeip" {
  account_id = "kubeip-serviceaccount"
  project    = var.project_id

}

resource "google_project_iam_member" "iam_member_kubeip" {
  role       = google_project_iam_custom_role.kubeip.id
  project    = var.project_id
  member     = google_service_account.kubeip.member
}