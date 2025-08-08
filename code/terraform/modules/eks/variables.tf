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

variable "cluster_name" {
  type        = string
  description = "Cluster name"
}

variable "eks_worker_subnet_ids" {
  type        = list(string)
  description = "EKS worker subnet IDs"
}

variable "bastion_host_id" {
  type        = string
  description = "Bastion Host Instance ID"
}

variable "eks_control_plane_security_group_id" {
  type        = string
  description = "EKS Control Plane Security Group ID"
}

variable "bastion_host_role_arn" {
  type        = string
  description = "Bastion host role ARN"
}

variable "eks_worker_ng_lt_image_id" {
  type        = string
  description = "EKS worker node group launch template image ID"
}

variable "eks_worker_ng_lt_instance_type" {
  type        = string
  description = "EKS worker node group launch template instance type"
}

variable "eks_worker_ng_name"{
  type = string
}

variable "eks_worker_ng_role_arn"{
  type = string
}


variable "eks_worker_ng_subnet_ids"{
  type = list(string)
}

variable "eks_worker_ng_lt_id"{
  description = "id of launch template for node group"
  type = string
}

variable "eks_worker_ng_desired_size"{
  type = number
}

variable "eks_worker_ng_min_size"{
  type = number
}

variable "eks_worker_ng_max_size"{
  type = number
}