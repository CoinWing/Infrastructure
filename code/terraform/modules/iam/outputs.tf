output "bastion_instance_profile_name" {
  description = "Bastion instance profile name"
  value       = aws_iam_instance_profile.bastion_host.name
}

output "eks_cluster_role_arn" {
  description = "EKS cluster role ARN"
  value       = aws_iam_role.eks_cluster.arn
}

output "bastion_host_role_arn" {
  description = "Bastion host role ARN"
  value       = aws_iam_role.bastion_host.arn
}