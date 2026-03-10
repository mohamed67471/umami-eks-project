output "eks_cluster_role_arn" {
  description = "ARN of EKS Cluster IAM role"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_cluster_role_name" {
  description = "Name of EKS Cluster IAM role"
  value       = aws_iam_role.eks_cluster.name
}

# EKS Node Group Role
output "eks_node_role_arn" {
  description = "ARN of EKS Node Group IAM role"
  value       = aws_iam_role.eks_node_group.arn
}

output "eks_node_role_name" {
  description = "Name of EKS Node Group IAM role"
  value       = aws_iam_role.eks_node_group.name
}

# Custom Policies
output "external_dns_policy_arn" {
  description = "ARN of ExternalDNS IAM policy"
  value       = aws_iam_policy.external_dns.arn
}





output "external_dns_role_arn" {
  description = "ARN of the External DNS IAM role"
  value       = aws_iam_role.external_dns.arn
}


output "cert_manager_role_arn" {
  description = "ARN of the cert-manager IAM role"
  value       = aws_iam_role.cert_manager.arn
}