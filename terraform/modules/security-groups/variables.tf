variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block for intra-VPC traffic rules"
  type        = string
  default     = "10.0.0.0/16"
}

variable "admin_cidr" {
  description = "Admin IP CIDR for kubectl access to EKS API"
  type        = string
  default     = ""
}


variable "name_prefix" {
  description = "Prefix for all security group names"
  type        = string
  default     = "umami-eks"
}

variable "tags" {
  description = "Additional tags for all security groups"
  type        = map(string)
  default     = {}
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}