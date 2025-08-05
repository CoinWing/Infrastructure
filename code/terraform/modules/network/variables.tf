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

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets"
}

variable "bastion_subnet" {
  type        = string
  description = "Bastion subnet"
}

variable "nat_instance_subnet" {
  type        = string
  description = "NAT instance subnet"
}

variable "rds_subnets" {
  type        = list(string)
  description = "RDS subnets"
}

variable "eks_worker_subnets" {
  type        = list(string)
  description = "EKS worker subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones"
}