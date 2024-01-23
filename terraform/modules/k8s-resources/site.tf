resource "kubernetes_deployment" "site" {
  metadata {
    name      = "site"
    namespace = local.namespace
    labels = {
      app     = "site"
      part-of = local.namespace
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app     = "site"
        part-of = local.namespace
      }
    }

    template {
      metadata {
        labels = {
          app     = "site"
          part-of = local.namespace
        }
      }

      spec {
        container {
          image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.name}/${var.site_image}"
          name  = "site"
          port {
            container_port = 8080
          }
          liveness_probe {
            http_get {
              path = "/health"
              port = 8080
            }

            initial_delay_seconds = 10
            period_seconds        = 3
          }
        }
        node_selector = {
          nodegroup                       = "site"
          kubeip                          = "ignore"
          "cloud.google.com/gke-nodepool" = data.terraform_remote_state.site_resources.outputs.site_pool
        }
      }
    }
  }
}

resource "kubernetes_service" "site" {
  metadata {
    name      = "site"
    namespace = local.namespace
    labels = {
      app     = "site"
      part-of = local.namespace
    }
  }
  spec {
    selector = {
      app = kubernetes_deployment.site.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 8080
    }
  }
}