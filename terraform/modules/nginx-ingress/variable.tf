variable "namespace" {
  description = "Kubernetes namespace for NGINX Ingress"
  type        = string
  default     = "ingress-nginx"
}

variable "http_node_port" {
  description = "NodePort for HTTP traffic"
  type        = number
  default     = 30262
}

variable "https_node_port" {
  description = "NodePort for HTTPS traffic"
  type        = number
  default     = 30315
}

variable "load_balancer_type" {
  description = "AWS load balancer type"
  type        = string
  default     = "nlb"
}

variable "eks_cluster_id" {
  description = "EKS cluster ID for dependency"
  type        = string
  default     = ""
}