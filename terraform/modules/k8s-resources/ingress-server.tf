resource "kubernetes_deployment" "ingress_server" {
  metadata {
    name      = "ingress-server"
    namespace = local.namespace
    labels = {
      app     = "ingress-server"
      part-of = local.namespace
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "ingress-server"
        part-of = local.namespace
      }
    }

    template {
      metadata {
        labels = {
          app     = "ingress-server"
          part-of = local.namespace
        }
      }

      spec {
        host_network = true
        dns_policy   = "ClusterFirstWithHostNet"
        container {
          image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.name}/${var.ingress_server_image}"
          name  = "ingress-server"
          port {
            name           = "http"
            container_port = 80
            host_port      = 80
          }
          port {
            name           = "https"
            container_port = 443
            host_port      = 443
          }
          volume_mount {
            name       = "certificates"
            mount_path = "/certificates"
            read_only  = true
          }
        }
        volume {
          name = "certificates"
          secret {
            secret_name = "certificates"
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