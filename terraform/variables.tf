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

variable "cluster_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "cluster_sg_ids" {
  type = list(string)
}
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the EKS cluster will be created"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}


variable "alb_dns_name" {
  description = "DNS name of the ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "Hosted zone ID of the ALB"
  default     = "Z26RNL4JYFTOTI"
}

variable "route53_zone_id" {
  description = "Hosted zone ID in Route 53 for the domain"
  type        = string
}

variable "eks_cluster_id" {
  description = "EKS cluster ID for dependency"
  type        = string
  default     = "umami-cluster"
}