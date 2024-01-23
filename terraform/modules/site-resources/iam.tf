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
    "compute.instances.addAccessConfig",
    "compute.instances.deleteAccessConfig",
    "compute.instances.get",
    "compute.addresses.get",
    "compute.addresses.list",
    "compute.addresses.use",
    "compute.zoneOperations.get",
    "compute.zoneOperations.list",
    "compute.subnetworks.useExternalIp",
    "compute.projects.get"
  ]
}

resource "google_service_account" "kubeip" {
  account_id = "${var.name}-kubeip-${var.environment}"
  project    = var.project_id
}

resource "google_project_iam_member" "iam_member_kubeip" {
  role    = google_project_iam_custom_role.kubeip.id
  project = var.project_id
  member  = google_service_account.kubeip.member
}

resource "google_service_account_iam_member" "kubeip_workload_identity_binding" {
  service_account_id = google_service_account.kubeip.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[kube-system/kubeip-service-account]"
}