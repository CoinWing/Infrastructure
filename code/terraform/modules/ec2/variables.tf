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

variable "nat_instance_subnet_id" {
  type        = string
  description = "Subnet ID where NAT instance will be placed"
}

variable "nat_security_group_id" {
  type        = string
  description = "Security group ID for NAT instance"
}