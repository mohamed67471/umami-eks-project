resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = var.cert_manager_namespace
  create_namespace = true
  version          = var.cert_manager_chart_version
  depends_on       = [var.iam_role_dependency]

  set = [
    {
      name  = "installCRDs"
      value = var.cert_manager_install_crds
    },
    {
      name  = "serviceAccount.create"
      value = true
    },
    {
      name  = "serviceAccount.name"
      value = var.cert_manager_service_account_name
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = var.cert_manager_iam_role_arn
    }
  ]
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  namespace        = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  version          = "1.4.0"
  timeout          = 1200
  create_namespace = true

  set = [
    {
      name  = "provider"
      value = "aws"
    },
    {
      name  = "aws.region"
      value = var.region
    },
    {
      name  = "domainFilters[0]"
      value = var.domain_name
    },
    {
      name  = "policy"
      value = var.external_dns_policy
    },
    {
      name  = "serviceAccount.name"
      value = "external-dns"
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = var.external_dns_iam_role_arn
    },
    {
      name  = "txtOwnerId"
      value = "umami-cluster"
    },
    {
      name  = "aws.preferCNAME"
      value = "true"
    }
  ]
}

resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = var.monitoring_namespace
  version          = "65.0.0"
  create_namespace = true
  timeout          = 600
  depends_on       = [var.eks_cluster_id]

  values = [
    yamlencode({
      prometheus = {
        prometheusSpec = {
          retention = "7d"
        }
      }

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
}

resource "helm_release" "nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = var.nginx_namespace
  create_namespace = true
  timeout          = 600

  values = [yamlencode({
    controller = {
      service = {
        type = "LoadBalancer"
        annotations = {
          "service.beta.kubernetes.io/aws-load-balancer-type"                              = "nlb"
          "service.beta.kubernetes.io/aws-load-balancer-scheme"                            = "internet-facing"
          "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" = "true"
        }
      }
    }
  })]
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  timeout          = 600
  namespace        = var.argocd_namespace
  create_namespace = true

  values = [
    file("${path.module}/values.yaml")
  ]
}

# ESO 
resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  version          = "0.9.11"
  create_namespace = true
  timeout          = 600
  depends_on       = [var.eks_cluster_id]

  set = [
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = var.external_secrets_role_arn
    }
  ]
}