variable "project_name" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "region" {
  type        = string
  description = "Region"
}

variable "cluster_role_arn" {
  type        = string
  description = "Cluster role ARN"
}

variable "cluster_version" {
  type        = string
  description = "Cluster version"
}

variable "eks_worker_subnet_ids" {
  type        = list(string)
  description = "EKS worker subnet IDs"
}

variable "bastion_host_id" {
  type        = string
  description = "Bastion Host Instance ID"
}