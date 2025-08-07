## BASTION HOST ##
# IAM Role for Bastion Host
resource "aws_iam_role" "bastion_host" {
  name_prefix = "${var.project_name}-${var.env}-bastion-host"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.env}-bastion-host-role"
  }
}

resource "aws_iam_role_policy_attachment" "bastion_host_ssm" {
  role       = aws_iam_role.bastion_host.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

## EKS CLUSTER ##
# EKS Cluster Role
resource "aws_iam_role" "eks_cluster" {
  name = "${var.project_name}-${var.env}-eks-cluster"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.env}-eks-cluster-role"
  }
}

# 쿠버네티스가 요구하는 권한을 부여
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# VPC Resource Controller가 워커 노드의 ENI와 IP를 관리하기 위한 정책
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster.name
}