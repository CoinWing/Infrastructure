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

variable "node_group_instance_type" {
  type        = string
  description = "Node group instance type"
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

variable "launch_template_image_id" {
  type        = string
  description = "Launch template image ID"
}

variable "domain_name" {
  type        = string
  description = "Domain name"
}

variable "rds_instance_type" {
  type        = string
  description = "RDS instance type"
}

variable "rds_db_name" {
  type        = string
  description = "RDS database name"
}

variable "rds_username" {
  type        = string
  description = "RDS username"
}

variable "rds_password" {
  type        = string
  description = "RDS password"
}

variable "rds_engine" {
  type        = string
  description = "RDS engine"
}

variable "rds_engine_version" {
  type        = string
  description = "RDS engine version"
}

variable "rds_port" {
  type        = string
  description = "RDS port"
}

variable "rds_parameter_group_family" {
  type        = string
  description = "RDS parameter group family"
}

variable "webhook" {
  type        = string
  description = "Discord Webhook URL"
}

variable "dockerconfigjson_data" {
  type        = string
  description = "Docker config JSON data"
}