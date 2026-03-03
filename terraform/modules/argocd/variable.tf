variable "chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "7.0.0"
}

variable "namespace" {
  description = "Namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "domain_name" {
  description = "Domain name for ArgoCD ingress"
  type        = string
  default     = ""
}

variable "eks_cluster_id" {
  description = "EKS cluster ID for dependency"
  type        = string
}