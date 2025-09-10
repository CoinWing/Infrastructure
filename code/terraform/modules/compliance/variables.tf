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
  description = "AWS region"
}

# Compliance Standards
variable "enable_cis_standard" {
  type        = bool
  description = "Enable CIS AWS Foundations Benchmark"
  default     = true
}

variable "enable_pci_standard" {
  type        = bool
  description = "Enable PCI DSS standard"
  default     = false
}

variable "enable_nist_standard" {
  type        = bool
  description = "Enable NIST Cybersecurity Framework"
  default     = true
}

# Logging
variable "log_retention_days" {
  type        = number
  description = "CloudWatch log retention in days"
  default     = 30
}

# Notifications
variable "compliance_email" {
  type        = string
  description = "Email address for compliance alerts"
  default     = null
}

variable "compliance_lambda_arn" {
  type        = string
  description = "Lambda function ARN for compliance alerts"
  default     = null
}

# Config Rules
variable "custom_config_rules" {
  type = list(object({
    name        = string
    description = string
    source = object({
      owner             = string
      source_identifier = string
    })
    input_parameters = optional(string)
  }))
  description = "Custom AWS Config rules"
  default     = []
}

# CloudTrail Settings
variable "cloudtrail_include_global_service_events" {
  type        = bool
  description = "Include global service events in CloudTrail"
  default     = true
}

variable "cloudtrail_is_multi_region_trail" {
  type        = bool
  description = "Enable multi-region CloudTrail"
  default     = true
}

variable "cloudtrail_event_selectors" {
  type = list(object({
    read_write_type           = string
    include_management_events = bool
    data_resources = optional(list(object({
      type   = string
      values = list(string)
    })))
  }))
  description = "CloudTrail event selectors"
  default = [
    {
      read_write_type           = "All"
      include_management_events = true
      data_resources = [
        {
          type   = "AWS::S3::Object"
          values = ["arn:aws:s3:::"]
        },
        {
          type   = "AWS::DynamoDB::Table"
          values = ["arn:aws:dynamodb:::"]
        },
        {
          type   = "AWS::Lambda::Function"
          values = ["arn:aws:lambda:::"]
        }
      ]
    }
  ]
}

# CloudWatch Alarms
variable "enable_cloudwatch_alarms" {
  type        = bool
  description = "Enable CloudWatch alarms for compliance"
  default     = true
}

variable "alarm_threshold_config_compliance" {
  type        = number
  description = "Threshold for config compliance alarm"
  default     = 0
}

variable "alarm_threshold_security_hub_findings" {
  type        = number
  description = "Threshold for security hub findings alarm"
  default     = 0
}

# Dashboard
variable "enable_compliance_dashboard" {
  type        = bool
  description = "Enable CloudWatch compliance dashboard"
  default     = true
}