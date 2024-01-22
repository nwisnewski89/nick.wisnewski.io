resource "kubernetes_config_map_v1" "kubeip" {
  metadata {
    name      = "kubeip-config"
    namespace = "kube-system"
    labels = {
      app = "kubeip"
    }
  }

  data = {
    KUBEIP_LABELKEY            = "kubeip"
    KUBEIP_LABELVALUE          = data.terraform_remote_state.site_resources.outputs.static_ingress
    KUBEIP_SELF_NODEPOOL       = data.terraform_remote_state.site_resources.outputs.app_pool
    KUBEIP_NODEPOOL            = data.terraform_remote_state.site_resources.outputs.ingress_pool
    KUBEIP_FORCEASSIGNMENT     = true
    KUBEIP_ADDITIONALNODEPOOLS = ""
    KUBEIP_TICKER              = 5
    KUBEIP_ALLNODEPOOLS        = false
  }
}

resource "kubernetes_service_account_v1" "kubeip" {
  metadata {
    name      = data.terraform_remote_state.site_resources.outputs.kubeip
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_v1" "kubeip" {
  metadata {
    name      = data.terraform_remote_state.site_resources.outputs.kubeip
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch", "patch"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "kubeip" {
  metadata {
    name = data.terraform_remote_state.site_resources.outputs.kubeip
  }
  subject {
    kind      = "ServiceAccount"
    name      = data.terraform_remote_state.site_resources.outputs.kubeip
    namespace = "kube-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = data.terraform_remote_state.site_resources.outputs.kubeip
  }

  depends_on = [
    kubernetes_service_account_v1.kubeip,
    kubernetes_service_account_v1.kubeip,
  ]
}