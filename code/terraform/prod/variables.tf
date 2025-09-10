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

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones"
}

variable "bastion_instance_type" {
  type        = string
  description = "Bastion instance type"
}

variable "cluster_version" {
  type        = string
  description = "Cluster version"
}

variable "node_group_instance_type" {
  type        = string
  description = "Node group instance type"
}

variable "node_group_desired_size" {
  type        = number
  description = "Node group desired size"
}

variable "node_group_min_size" {
  type        = number
  description = "Node group min size"
}

variable "node_group_max_size" {
  type        = number
  description = "Node group max size"
}

variable "launch_template_image_id" {
  type        = string
  description = "Launch template image ID"
}

variable "domain_name" {
  type        = string
  description = "Domain name"
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
  sensitive   = true
}

variable "rds_engine" {
  type        = string
  description = "RDS engine"
}

variable "rds_engine_version" {
  type        = string
  description = "RDS engine version"
}

variable "rds_port" {
  type        = string
  description = "RDS port"
}

variable "rds_parameter_group_family" {
  type        = string
  description = "RDS parameter group family"
}

variable "webhook" {
  type        = string
  description = "Discord Webhook URL"
  sensitive   = true
}

variable "github_username" {
  type        = string
  description = "GitHub username"
}

variable "github_password" {
  type        = string
  description = "GitHub password"
  sensitive   = true
}

variable "github_email" {
  type        = string
  description = "GitHub email"
}

variable "jwt_secret" {
  type        = string
  description = "JWT secret"
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

variable "enable_compliance_dashboard" {
  type        = bool
  description = "Enable CloudWatch compliance dashboard"
  default     = true
}