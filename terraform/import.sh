
echo "Importing Security Groups..."
terraform import module.security_groups.aws_security_group.nlb sg-0c2d99c72c7d0f993
terraform import module.security_groups.aws_security_group.eks_cluster sg-0a8aa6fd770ca7f40
terraform import module.security_groups.aws_security_group.eks_nodes_sg sg-03b7a0f91ecb541af
terraform import module.security_groups.aws_security_group.rds_sg sg-0c5ff9104aec0eb08
terraform import module.security_groups.aws_security_group.lb sg-09fe3088173735940
terraform import module.security_groups.aws_security_group.alb sg-02ae61485902d5007

echo "Importing IAM Roles..."
terraform import module.iam.aws_iam_role.eks_cluster umami-eks-cluster-role
terraform import module.iam.aws_iam_role.eks_node_group umami-eks-node-group-role

echo "Importing IAM Policy Attachments..."
terraform import module.iam.aws_iam_role_policy_attachment.eks_cluster_policy umami-eks-cluster-role/arn:aws:iam::aws:policy/AmazonEKSClusterPolicy
terraform import module.iam.aws_iam_role_policy_attachment.eks_vpc_resource_controller umami-eks-cluster-role/arn:aws:iam::aws:policy/AmazonEKSVPCResourceController
terraform import module.iam.aws_iam_role_policy_attachment.eks_worker_node_policy umami-eks-node-group-role/arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy
terraform import module.iam.aws_iam_role_policy_attachment.eks_cni_policy umami-eks-node-group-role/arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy
terraform import module.iam.aws_iam_role_policy_attachment.ecr_read_only umami-eks-node-group-role/arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly

echo ""
echo "✅ Import complete!"
echo ""
echo "Next steps:"
echo "1. Run: terraform plan"
echo "2. Review the changes (should add NLB rules and fix the wrong ones)"
echo "3. Run: terraform apply"
