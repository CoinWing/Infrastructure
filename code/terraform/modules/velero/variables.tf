variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "cluster_ca_data" {
  description = "EKS Cluster Certificate"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "EKS OIDC issuer url"
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "bucket_name" {
  description = "Velero bucket name"
  type        = string
}

variable "namespace" {
    description = "Velero namespace"
    type        = string
}

variable "helm_chart_version" {
  description = "Velero Helm Chart version"
  type        = string
}

variable "velero_image_version" {
  description = "Velero image version"
  type        = string
}

variable "velero_plugin_version" {
  description = "Velero Plugin for aws version"
  type        = string
}