output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value       = module.eks.cluster_certificate_authority_data
  sensitive   = true
  description = "base64 encoded certification data for kubernetes cluster"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "configure_kubectl" {
  value = "aws eks --region ${var.aws_region} update-kubeconfig --name ${var.cluster_name}"
}