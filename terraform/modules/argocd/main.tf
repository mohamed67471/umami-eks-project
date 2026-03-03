resource "helm_release" "argocd_deploy" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  timeout    = "6000"


  namespace        = var.namespace
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]

}
resource "kubernetes_ingress_v1" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = var.namespace
    annotations = {
      "cert-manager.io/cluster-issuer"                                                      = "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/backend-protocol"                                        = "HTTP"
      "nginx.ingress.kubernetes.io/ssl-redirect"                                            = "true"
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled"      = "true"  
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = "argocd.${var.domain_name}"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }

    tls {
      hosts       = ["argocd.${var.domain_name}"]
      secret_name = "argocd-server-tls"
    }
  }

  depends_on = [helm_release.argocd_deploy]
}