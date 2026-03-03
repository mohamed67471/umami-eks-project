resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  
  client_id_list = [
    "sts.amazonaws.com",
  ]
  
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
  
  tags = {
    Name    = "github-actions-oidc"
    Project = "umami-eks"
  }
}

# IAM Role for GitHub Actions 
resource "aws_iam_role" "github_actions_eks" {
  name = "github-actions-eks-deploy-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:mohamed67471/umami-eks-project:*"
          }
        }
      }
    ]
  })
  
  tags = {
    Name    = "github-actions-eks-role"
    Project = "umami-eks"
  }
}

# Policy for Terraform operations 
resource "aws_iam_role_policy" "github_actions_terraform" {
  name = "github-actions-terraform-policy"
  role = aws_iam_role.github_actions_eks.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          # S3 for Terraform state
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::umami-terraform-state-2026",
          "arn:aws:s3:::umami-terraform-state-2026/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          
          "eks:*",
          
          "ec2:*",
          
          "iam:*",
          
          "rds:*",
          
          "route53:*",
          
          "logs:*",
          
          "elasticloadbalancing:*",
          
          "autoscaling:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Policy for ECR (Docker images)
resource "aws_iam_role_policy" "github_actions_ecr" {
  name = "github-actions-ecr-policy"
  role = aws_iam_role.github_actions_eks.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:CreateRepository",
          "ecr:DescribeRepositories"
        ]
        Resource = "*"
      }
    ]
  })
}

# Output the role ARN for GitHub Actions
output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions IAM role for EKS deployment"
  value       = aws_iam_role.github_actions_eks.arn
  sensitive   = false
}