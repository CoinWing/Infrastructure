# Bastion Host에서 EKS 접근 권한 추가
resource "aws_eks_access_entry" "bastion_host" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  principal_arn = var.bastion_host_role_arn
  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "bastion_admin" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  principal_arn = var.bastion_host_role_arn
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.bastion_host]
}