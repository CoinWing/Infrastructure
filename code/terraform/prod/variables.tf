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

variable "vpc_main_subnet" {
  type        = string
  description = "Main VPC subnet"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones"
}

variable "bastion_instance_type" {
  type        = string
  description = "Bastion instance type"
}

variable "cluster_version" {
  type        = string
  description = "Cluster version"
}

variable "node_group_instance_types" {
  type        = list(string)
  description = "Node group instance types"
}

variable "node_group_desired_size" {
  type        = number
  description = "Node group desired size"
}

variable "node_group_min_size" {
  type        = number
  description = "Node group min size"
}

variable "node_group_max_size" {
  type        = number
  description = "Node group max size"
}