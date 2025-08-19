variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "Files"
}

variable "dynamodb_hash_key" {
  description = "The hash key of the DynamoDB table"
  type        = string
  default     = "FileName"
}

variable "lambda_name" {
  description = "The name of the Lambda function"
  type        = string
  default     = "upload_trigger_lambda"
}

variable "enable_ec2" {
  description = "Enable creation of EC2 test stack (VPC, subnets, SGs, bastion, NAT)"
  type        = bool
  default     = false
}

