variable "namespace" {
  description = "Namespace for monitoring stack"
  type        = string
  default     = "monitoring"
}

variable "domain_name" {
  description = "Domain name for Grafana ingress"
  type        = string
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
}

variable "eks_cluster_id" {
  description = "EKS cluster ID for dependency"
  type        = string
}