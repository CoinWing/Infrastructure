variable "project_name" {
  type        = string
  description = "The name of the project"
}

variable "env" {
  type        = string
  description = "The environment"
}

variable "dockerconfigjson_data" {
  sensitive   = true
  type        = string
  description = "The Docker config JSON data"
}
