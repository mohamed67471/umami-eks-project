variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "umami-cluster"
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role for EKS cluster control plane"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM role for EKS worker nodes"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where EKS nodes will be deployed"
  type        = list(string)
}

variable "cluster_sg_ids" {
  description = "List of security group IDs for EKS control plane"
  type        = list(string)
}

variable "cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.29"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of worker nodes for autoscaling"
  type        = number
  default     = 3
}

variable "node_min_size" {
  description = "Minimum number of worker nodes for autoscaling"
  type        = number
  default     = 1
}

variable "node_instance_types" {
  description = "List of EC2 instance types for worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
variable "eks_nodes_sg_id" {
  type = string
}

variable "eks_node_group_name" {
  description = "name of the node"
  type        = string
  default     = "umami-cluster-node-group"

}

variable "admin_cidr_list" {
  description = "Admin IP CIDR blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}