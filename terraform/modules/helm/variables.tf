# shared
variable "region" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "iam_role_dependency" {
  type    = any
  default = null
}

variable "eks_cluster_id" {
  type    = any
  default = null
}

# cert-manager
variable "cert_manager_namespace" {
  type    = string
  default = "cert-manager"
}

variable "cert_manager_chart_version" {
  type = string
}

variable "cert_manager_install_crds" {
  type    = bool
  default = true
}

variable "cert_manager_service_account_name" {
  type    = string
  default = "cert-manager"
}

variable "cert_manager_iam_role_arn" {
  type = string
}

# external-dns
variable "external_dns_policy" {
  type    = string
  default = "sync"
}

variable "external_dns_iam_role_arn" {
  type = string
}

# monitoring
variable "monitoring_namespace" {
  type    = string
  default = "monitoring"
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
}

# nginx
variable "nginx_namespace" {
  type    = string
  default = "ingress-nginx"
}

# argocd
variable "argocd_namespace" {
  type    = string
  default = "argocd"
}

variable "argocd_chart_version" {
  type = string
}

variable "external_secrets_role_arn" {
  type = string
}