variable "project_name" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "lambda_function" {
  description = "Lambda subscribed to SNS"
  type = string
}