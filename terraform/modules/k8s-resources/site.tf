resource "kubernetes_namespace_v1" "wisnewski" {
  metadata {
    name = "wisnewski-io"
  }
}

resource "kubernetes_service_v1" "site" {
  metadata {
    name = "site"
    namespace = kubernetes_namespace_v1.wisnewski.metadata.0.name
  }
  spec {
    selector = {
      app = "site"
    }

    port {
      port        = 8080
      target_port = 8080
    }

    type = "ClusterIP"
  }
}