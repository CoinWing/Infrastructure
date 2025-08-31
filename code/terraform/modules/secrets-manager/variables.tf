variable "project_name" {
  type        = string
  description = "The name of the project"
}

variable "env" {
  type        = string
  description = "The environment"
}

variable "github_username" {
  type        = string
  description = "The username of the GitHub account"
}

variable "github_password" {
  type        = string
  description = "The password of the GitHub account"
  sensitive   = true
}

variable "github_email" {
  type        = string
  description = "The email of the GitHub account"
}

variable "jwt_secret" {
  type        = string
  description = "The JWT secret"
  sensitive   = true
}

variable "mariadb_username" {
  type        = string
  description = "MariaDB username"
}

variable "mariadb_password" {
  type        = string
  description = "MariaDB password"
  sensitive   = true
}

variable "redis_password" {
  type        = string
  description = "Redis password"
  sensitive   = true
}

variable "queue_name" {
  type        = string
  description = "Queue name"
}

variable "pd_redis_password" {
  type        = string
  description = "PD Redis password"
  sensitive   = true
}

variable "access_key" {
  type        = string
  description = "Access key"
  sensitive   = true
}

variable "secret_key" {
  type        = string
  description = "Secret key"
  sensitive   = true
}

variable "sqs_uri" {
  type        = string
  description = "SQS URI"
}