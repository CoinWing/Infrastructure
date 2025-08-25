variable "project_name" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment"
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

variable "rds_db_subnet_ids" {
  type        = list(string)
  description = "RDS database subnet IDs"
}

variable "rds_security_group_id" {
  type        = string
  description = "RDS security group ID"
}

variable "rds_port" {
  type        = string
  description = "RDS port"
}

variable "rds_parameter_group_family" {
  type        = string
  description = "RDS parameter group family"
}

variable "rds_event_sns" {
  type = string
  description = "RDS Event for SNS"
}