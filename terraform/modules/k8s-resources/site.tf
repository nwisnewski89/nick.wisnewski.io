resource "kubernetes_namespace_v1" "wisnewski" {
  metadata {
    name = "wisnewski-io"
  }
}