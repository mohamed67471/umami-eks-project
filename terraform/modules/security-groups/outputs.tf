output "eks_cluster_sg_id" {
  description = "ID of the EKS cluster security group"
  value       = aws_security_group.eks_cluster.id
}

output "eks_nodes_sg_id" {
  description = "ID of the EKS nodes security group"
  value       = aws_security_group.eks_nodes_sg.id
}


output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}
output "rds_sg_id" {
  description = "Security group ID of the RDS instance"
  value       = aws_security_group.rds_sg.id
}

output "vpc_id" {
  description = "VPC ID where security groups are created"
  value       = var.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block used for rules"
  value       = var.vpc_cidr
}
