resource "aws_launch_template" "eks_worker_ng_lt" { # EKS Worker Node Group Launch Template
  image_id               = var.eks_worker_ng_lt_image_id
  instance_type          = var.eks_worker_ng_lt_instance_type

  user_data             = base64encode("#!/bin/bash\n/etc/eks/bootstrap.sh ${var.cluster_name}\n")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-${var.env}-eks-worker-instance"
    }
  }

  tags = {
    Name = "${var.project_name}-${var.env}-eks-worker-ng-lt"
  }

  depends_on = [aws_eks_cluster.eks_cluster]
}

resource "aws_eks_node_group" "eks_worker_ng" { # EKS Worker Node Group
  cluster_name    = var.cluster_name
  node_group_name = var.eks_worker_ng_name
  node_role_arn   = var.eks_worker_ng_role_arn
  subnet_ids      = var.eks_worker_ng_subnet_ids

  scaling_config {
    desired_size = var.eks_worker_ng_desired_size
    max_size     = var.eks_worker_ng_max_size
    min_size     = var.eks_worker_ng_min_size
  }
  launch_template {
    id      = var.eks_worker_ng_lt_id
    version = "$Latest"
  }

  tags = {
    Name = "${var.project_name}-${var.env}-eks-worker-ng"
  }

  depends_on = [aws_launch_template.eks_worker_ng_lt]
}