# Prometheus Helm Release
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = var.namespace
  version    = "65.0.0"

  create_namespace = true
  timeout          = 600

  values = [
    yamlencode({

      prometheus = {
        prometheusSpec = {
          retention = "7d"

        }
      }

      # Grafana configuration
      grafana = {
        enabled       = true
        adminPassword = var.grafana_admin_password

        ingress = {
          enabled          = true
          ingressClassName = "nginx"
          annotations = {
            "cert-manager.io/cluster-issuer"           = "letsencrypt-prod"
            "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
          }
          hosts = ["grafana.${var.domain_name}"]
          tls = [{
            secretName = "grafana-tls"
            hosts      = ["grafana.${var.domain_name}"]
          }]
        }

        persistence = {
          enabled = false
        }

        # Pre-configure dashboards
        dashboardProviders = {
          "dashboardproviders.yaml" = {
            apiVersion = 1
            providers = [{
              name            = "default"
              orgId           = 1
              folder          = ""
              type            = "file"
              disableDeletion = false
              options = {
                path = "/var/lib/grafana/dashboards/default"
              }
            }]
          }
        }
      }

      kubeStateMetrics = {
        enabled = true
      }

      nodeExporter = {
        enabled = true
      }

      alertmanager = {
        enabled = false
      }
    })
  ]

  depends_on = [var.eks_cluster_id]
}