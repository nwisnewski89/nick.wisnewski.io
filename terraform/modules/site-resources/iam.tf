resource "google_project_iam_custom_role" "k8s" {
  role_id = "${var.name}_k8s_${var.environment}_role"
  title   = "K8s service account cluster role"
  project = var.project_id

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

resource "google_service_account" "k8s" {
  account_id = "${var.name}-k8s-${var.environment}"
  project    = var.project_id
}

resource "google_project_iam_member" "iam_member_kluster" {
  role    = google_project_iam_custom_role.k8s.id
  project = var.project_id
  member  = google_service_account.k8s.member
}

resource "google_project_iam_custom_role" "kubeip" {
  role_id = "${var.name}_kubeip_${var.environment}_role"
  title   = "K8s kubeip service account cluster role"
  project = var.project_id


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
  account_id = "${var.name}-kubeip-${var.environment}"
  project    = var.project_id
  depends_on = [google_project_iam_custom_role.kubeip]
}

resource "google_project_iam_member" "iam_member_kubeip" {
  role    = google_project_iam_custom_role.kubeip.id
  project = var.project_id
  member  = google_service_account.kubeip.member
}