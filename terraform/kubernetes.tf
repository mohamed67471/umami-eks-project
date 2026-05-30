resource "kubernetes_namespace" "umami" {
  metadata {
    name = "umami"
  }
}