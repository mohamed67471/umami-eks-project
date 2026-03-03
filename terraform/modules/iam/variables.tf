variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "umami-eks"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "umami-cluster"
}
variable "oidc_issuer" {
  type    = string
  default = ""
}

variable "oidc_provider_arn" {
  description = "ARN of the OIDC provider"
  type        = string
  default     = ""
}