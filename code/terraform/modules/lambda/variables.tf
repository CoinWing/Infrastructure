variable "project_name" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "webhook" {
  type        = string
  description = "Discord Webhook URL"
}

variable "rds_event_sns" {
  type = string
  description = "RDS Event for SNS"
}

variable "lambda_exec_role_arn" {
  type = string
  description = "Lambda execution role"
}

