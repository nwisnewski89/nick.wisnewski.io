resource "kubernetes_service_account" "kubeip_service_account" {
  metadata {
    name      = "kubeip-service-account"
    namespace = "kube-system"
    annotations = {
      "iam.gke.io/gcp-service-account" = data.terraform_remote_state.site_resources.outputs.kubeip_service_account
    }
  }
}

resource "kubernetes_cluster_role" "kubeip_cluster_role" {
  metadata {
    name = "kubeip-cluster-role"
  }
  rule {
    api_groups = ["*"]
    resources  = ["nodes"]
    verbs      = ["get"]
  }
}

resource "kubernetes_cluster_role_binding" "kubeip_cluster_role_binding" {
  metadata {
    name = "kubeip-cluster-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.kubeip_cluster_role.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.kubeip_service_account.metadata.0.name
    namespace = kubernetes_service_account.kubeip_service_account.metadata.0.namespace
  }
}

resource "kubernetes_daemonset" "kubeip_daemonset" {
  metadata {
    name      = "kubeip-agent"
    namespace = "kube-system"
    labels = {
      app = "kubeip"
    }
  }
  spec {
    selector {
      match_labels = {
        app = "kubeip"
      }
    }
    template {
      metadata {
        labels = {
          app = "kubeip"
        }
      }
      spec {
        service_account_name             = kubernetes_service_account.kubeip_service_account.metadata.0.name
        termination_grace_period_seconds = 30
        priority_class_name              = "system-node-critical"
        container {
          name  = "kubeip-agent"
          image = "doitintl/kubeip-agent"
          env {
            name = "NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          env {
            name  = "FILTER"
            value = data.terraform_remote_state.site_resources.outputs.kubeip_filter
          }
          env {
            name  = "LOG_LEVEL"
            value = "debug"
          }
          env {
            name  = "LOG_JSON"
            value = "true"
          }
          resources {
            requests = {
              cpu = "100m"
            }
          }
        }
        node_selector = {
          nodegroup                       = "ingress"
          kubeip                          = "use"
          "cloud.google.com/gke-nodepool" = data.terraform_remote_state.site_resources.outputs.ingress_pool
        }
      }
    }
  }
}