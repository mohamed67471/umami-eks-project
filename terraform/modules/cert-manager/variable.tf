variable "namespace" {
  description = "Kubernetes namespace for cert-manager"
  type        = string
  default     = "cert-manager"
}

variable "chart_version" {
  description = "cert-manager Helm chart version"
  type        = string
  default     = "v1.13.3"
}

variable "install_crds" {
  description = "Install cert-manager CRDs"
  type        = bool
  default     = true
}

variable "service_account_name" {
  description = "Name of the service account"
  type        = string
  default     = "cert-manager"
}

variable "iam_role_arn" {
  description = "ARN of IAM role for cert-manager"
  type        = string
}

variable "iam_role_dependency" {
  description = "Dependency on IAM role attachment"
  type        = any
  default     = null
}
