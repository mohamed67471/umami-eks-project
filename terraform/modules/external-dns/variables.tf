variable "domain_name" {
  type = string
}

variable "iam_role_arn" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "zone_type" {
  description = "Type of Route53 zones to manage (public or private)"
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.zone_type)
    error_message = "Zone type must be either 'public' or 'private'."
  }
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "helm_version" {
  description = "Version of ExternalDNS Helm chart"
  type        = string
  default     = "6.28.5"
}

variable "policy" {
  description = "DNS record management policy"
  type        = string
  default     = "sync"

  validation {
    condition     = contains(["sync", "upsert-only"], var.policy)
    error_message = "Policy must be either 'sync' or 'upsert-only'."
  }
}

variable "helm_timeout" {
  description = "Timeout for Helm operations"
  type        = number
  default     = 600
}