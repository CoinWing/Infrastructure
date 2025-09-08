output "eks_worker_ng_lt_id" {
  value = aws_launch_template.eks_worker_ng_lt.id
}

output "cluster_endpoint" {
  description = "EKS Cluter API Server Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "EKS Cluter Certificate Data"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value      = module.eks.cluster_name
}

output "oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  value       = module.eks.oidc_provider_arn
}

output "cluster_oidc_issuer_url" {
  description = "EKS OIDC issuer url"
  value       = module.eks.cluster_oidc_issuer_url
}