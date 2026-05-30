module "vpc" {
  source = "./modules/vpc"

  name_prefix          = var.name_prefix
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

module "security_groups" {
  source = "./modules/security-groups"

  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = module.vpc.vpc_cidr_block
  admin_cidr   = var.admin_cidr
  cluster_name = var.cluster_name
}

module "eks" {
  source           = "./modules/eks"
  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  cluster_role_arn = module.iam.eks_cluster_role_arn
  node_role_arn    = module.iam.eks_node_role_arn
  subnet_ids       = module.vpc.private_subnet_ids
  cluster_sg_ids   = [module.security_groups.eks_cluster_sg_id]
  eks_nodes_sg_id  = module.security_groups.eks_nodes_sg_id
  admin_cidr_list  = var.admin_cidr_list
}

module "iam" {
  source            = "./modules/iam"
  name_prefix       = var.name_prefix
  cluster_name      = var.cluster_name
  oidc_issuer       = module.eks.oidc_issuer
  oidc_provider_arn = module.eks.oidc_provider_arn
}

module "rds" {
  source = "./modules/rds"

  name_prefix        = var.name_prefix
  db_password        = var.db_password
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id
}

module "helm" {
  source = "./modules/helm"

  # shared
  region      = var.aws_region
  domain_name = var.domain_name

  # cert-manager
  cert_manager_chart_version = "v1.13.0"
  cert_manager_iam_role_arn  = module.iam.cert_manager_role_arn
  iam_role_dependency        = module.iam

  # external-dns
  external_dns_iam_role_arn = module.iam.external_dns_role_arn

  # monitoring
  grafana_admin_password = var.grafana_admin_password
  eks_cluster_id         = module.eks.cluster_id

  # argocd
  argocd_chart_version = "5.51.0"
  #ESO
  external_secrets_role_arn = module.iam.external_secrets_role_arn
  depends_on = [
    module.eks,
    module.iam
  ]
}
