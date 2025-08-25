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

output "eks_worker_ng_role_arn" {
  description = "EKS worker node group role ARN"
  value       = aws_iam_role.eks_worker_ng.arn
}

output "lambda_exec_role_arn" {
  description = "lambda role ARN"
  value = aws_iam_role.lambda_exec.arn
}