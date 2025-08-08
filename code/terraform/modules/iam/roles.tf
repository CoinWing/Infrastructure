## BASTION HOST ##
# SSM 접근 권한 추가
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

# Bastion Host Role에 EKS 접근 권한 추가
resource "aws_iam_policy" "bastion_host_eks_access" {
  name        = "${var.project_name}-${var.env}-bastion-host-eks-access"
  description = "Policy for bastion host to access EKS clusters"
  policy      = file("${path.module}/bastion_host_policy.json")
}

resource "aws_iam_role_policy_attachment" "bastion_host_eks_access" {
  role       = aws_iam_role.bastion_host.name
  policy_arn = aws_iam_policy.bastion_host_eks_access.arn
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

# Node Group Role
resource "aws_iam_role" "eks_worker_ng" {
  name = "${var.project_name}-${var.env}-eks-worker-ng"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
    Name = "${var.project_name}-${var.env}-eks-worker-ng-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_worker_ng_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_ng.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_ng_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_ng.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_ng_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_ng.name
}

# ALB Ingress Controller IAM Policy
resource "aws_iam_policy" "aws_load_balancer_controller_iam_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/alb_controller_policy.json")
}