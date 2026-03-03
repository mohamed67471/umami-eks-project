resource "aws_security_group" "eks_cluster" {
  name        = "${var.name_prefix}-eks-cluster-sg"
  description = "Security group for EKS control plane"
  vpc_id      = var.vpc_id

  ingress {
    description     = "From EKS worker nodes"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_nodes_sg.id]
  }
  ingress {
    description = "From admin IP for kubectl"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-eks-sg"
  }
}

resource "aws_security_group" "eks_nodes_sg" {
  name        = "${var.name_prefix}-eks-nodes-sg"
  description = "security group for eks worker nodes"
  vpc_id      = var.vpc_id

  
  ingress {
    description = "From Load Balancers to NodePort/Services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    security_groups = [
      aws_security_group.alb.id,
      aws_security_group.nlb.id
    ]
  }

  #allow pods to talk to each other 
  ingress {
    description = "Pod to pod communication within cluster"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  #allow all traffic within the vpc 
  ingress {
    description = "all traffic with the vpc"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  #allow all outbond traffic 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-eks-nodes-sg"
  }
}


resource "aws_security_group" "lb" {
  name        = "${var.name_prefix}-lb-sg"
  description = "Security group for Load Balancers (ALB/NLB)"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-lb-sg"
  }
}

# Explicit NLB security group (AWS Load Balancer Controller will use this)
resource "aws_security_group" "nlb" {
  name        = "${var.name_prefix}-nlb-sg"
  description = "Security group for NLB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                        = "${var.name_prefix}-nlb-sg"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# Explicit rule for NLB to nodes on port 30262 (NGINX HTTP)
resource "aws_security_group_rule" "allow_nlb_to_nodes_30262" {
  type                     = "ingress"
  description              = "From NLB to NGINX HTTP NodePort"
  from_port                = 30262
  to_port                  = 30262
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.nlb.id
}

# Explicit rule for NLB to nodes on port 30315 (NGINX HTTPS)
resource "aws_security_group_rule" "allow_nlb_to_nodes_30315" {
  type                     = "ingress"
  description              = "From NLB to NGINX HTTPS NodePort"
  from_port                = 30315
  to_port                  = 30315
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.nlb.id
}

# UPDATED: Keep for backward compatibility if other resources reference it
resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Security group for ALB (legacy)"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-alb-sg"
  }
}

# UNCHANGED - RDS configuration is perfect
resource "aws_security_group" "rds_sg" {
  name        = "${var.name_prefix}-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-rds-sg"
  }
}

# rds rule 
resource "aws_security_group_rule" "rds_allow_eks_nodes" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
}