resource "aws_eks_cluster" "eks_cluster" {
  name = "${var.project_name}-${var.env}-eks"

  role_arn = var.cluster_role_arn
  version  = var.cluster_version

  upgrade_policy {
    support_type = "STANDARD"
  }

  vpc_config {
    subnet_ids = var.eks_worker_subnet_ids
    endpoint_private_access = true
    endpoint_public_access = false
    security_group_ids = [var.eks_control_plane_security_group_id]
  }

  access_config {
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
}