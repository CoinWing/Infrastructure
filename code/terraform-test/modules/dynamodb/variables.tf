variable "table_name" {
  type        = string
  description = "DynamoDB table name"
}

variable "hash_key" {
  type        = string
  description = "Partition key name"
}

variable "billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
  description = "Billing mode"
}

variable "pitr_enabled" {
  type        = bool
  default     = true
  description = "Enable point-in-time recovery"
}
