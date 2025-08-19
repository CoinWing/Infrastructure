variable "function_name" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "zip_path" {
  type = string
}

variable "zip_source_dir" {
  type = string
}

variable "timeout" {
  type    = number
  default = 120
}
