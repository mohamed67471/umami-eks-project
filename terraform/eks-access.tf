# Get current AWS caller identity
data "aws_caller_identity" "current" {}

# Extract role name from assumed role ARN (for GitHub Actions OIDC)
locals {

  is_assumed_role = can(regex("assumed-role", data.aws_caller_identity.current.arn))

  principal_arn = local.is_assumed_role ? (
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${split("/", data.aws_caller_identity.current.arn)[1]}"
    ) : (
    data.aws_caller_identity.current.arn
  )
}

# Add to EKS cluster access
resource "aws_eks_access_entry" "admin" {
  cluster_name      = module.eks.cluster_name
  principal_arn     = local.principal_arn
  kubernetes_groups = []
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = local.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.admin]
}
# test 