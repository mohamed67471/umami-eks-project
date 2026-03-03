
#launch template 

resource "aws_launch_template" "eks_nodes" {
  name_prefix = "${var.cluster_name}-nodes-"

  vpc_security_group_ids = [var.eks_nodes_sg_id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.cluster_name}-node"
    }
  }
}
# eks clust 
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = var.cluster_role_arn
  lifecycle {
    ignore_changes = [version]
  }

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.cluster_sg_ids
    endpoint_public_access  = true
    endpoint_private_access = false
  }
}

# eks nodes 
resource "aws_eks_node_group" "umami_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = var.eks_node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  # Use ON_DEMAND to avoid Spot issues
  capacity_type  = "ON_DEMAND"
  instance_types = var.node_instance_types
  ami_type       = "AL2_x86_64"

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  tags = {
    Name = var.eks_node_group_name
  }

  update_config {
    max_unavailable = 1
  }

  force_update_version = true
}

# oidc provider 
data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    data.tls_certificate.eks.certificates[0].sha1_fingerprint,
  ]
}