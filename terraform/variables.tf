variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "umami-cluster"
}

variable "domain_name" {
  description = "Your registered domain"
  type        = string
  default     = "mohamed-uptime.com"
}

variable "subdomain" {
  description = "Subdomain for Umami analytics"
  type        = string
  default     = "umami"
}

variable "admin_cidr" {
  description = "Admin CIDR for security groups"
  type        = string
  default     = "0.0.0.0/0"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "umami-eks"
}


variable "db_password" {
  description = "Database password for RDS PostgreSQL"
  type        = string
  sensitive   = true
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}


