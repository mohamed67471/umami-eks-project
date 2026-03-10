
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

module "external_dns" {
  source = "./modules/external-dns"

  cluster_name = var.cluster_name
  iam_role_arn = module.iam.external_dns_role_arn
  domain_name  = var.domain_name
  region       = var.aws_region

  depends_on = [module.eks]
}


module "nginx_ingress" {
  source = "./modules/nginx-ingress"

  eks_cluster_id = module.eks.cluster_id
}

module "cert_manager" {
  source = "./modules/cert-manager"


  iam_role_arn = "arn:aws:iam::715432480679:role/umami-eks-cert-manager-role"
  depends_on   = [module.eks]
}

module "argocd" {
  source = "./modules/argocd"


  namespace      = "argocd"
  domain_name    = "mohamed-uptime.com"
  eks_cluster_id = module.eks.cluster_id
}

module "monitoring" {
  source = "./modules/monitoring"

  namespace              = "monitoring"
  domain_name            = var.domain_name
  grafana_admin_password = var.grafana_admin_password
  eks_cluster_id         = module.eks.cluster_id

  depends_on = [
    module.eks,
    module.nginx_ingress,
    module.cert_manager
  ]
}