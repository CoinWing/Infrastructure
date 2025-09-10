variable "project_name" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "scope" {
  type        = string
  description = "WAF scope (CLOUDFRONT or REGIONAL)"
  default     = "REGIONAL"
  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "Scope must be either CLOUDFRONT or REGIONAL."
  }
}

variable "default_action" {
  type        = string
  description = "Default action for WAF (allow or block)"
  default     = "allow"
  validation {
    condition     = contains(["allow", "block"], var.default_action)
    error_message = "Default action must be either allow or block."
  }
}

# AWS Managed Rules
variable "enable_core_rule_set" {
  type        = bool
  description = "Enable AWS Managed Rules Core Rule Set"
  default     = true
}

variable "enable_known_bad_inputs" {
  type        = bool
  description = "Enable AWS Managed Rules Known Bad Inputs"
  default     = true
}

variable "enable_sql_injection" {
  type        = bool
  description = "Enable AWS Managed Rules SQL Injection"
  default     = true
}

variable "enable_linux_os" {
  type        = bool
  description = "Enable AWS Managed Rules Linux Operating System"
  default     = true
}

# Rate Limiting
variable "enable_rate_limiting" {
  type        = bool
  description = "Enable rate limiting"
  default     = true
}

variable "rate_limit" {
  type        = number
  description = "Rate limit per 5 minutes"
  default     = 2000
}

# Geo Blocking
variable "blocked_countries" {
  type        = list(string)
  description = "List of country codes to block"
  default     = []
}

# IP Set
variable "ip_set_arn" {
  type        = string
  description = "ARN of existing IP set to block"
  default     = null
}

variable "create_ip_set" {
  type        = bool
  description = "Create IP set for blocked IPs"
  default     = false
}

variable "blocked_ip_addresses" {
  type        = list(string)
  description = "List of IP addresses to block"
  default     = []
}

# Custom Rules
variable "custom_rules" {
  type = list(object({
    name           = string
    priority       = number
    action         = string
    statement_type = string
    byte_match = optional(object({
      search_string          = string
      field                  = string
      header_name           = optional(string)
      text_transformation   = string
      positional_constraint = string
    }))
    geo_match = optional(object({
      country_codes = list(string)
    }))
    ip_set = optional(object({
      arn = string
    }))
  }))
  description = "List of custom rules"
  default     = []
}

# Logging
variable "enable_logging" {
  type        = bool
  description = "Enable WAF logging"
  default     = true
}

variable "log_retention_days" {
  type        = number
  description = "CloudWatch log retention in days"
  default     = 14
}

# Monitoring
variable "cloudwatch_metrics_enabled" {
  type        = bool
  description = "Enable CloudWatch metrics"
  default     = true
}

variable "sampled_requests_enabled" {
  type        = bool
  description = "Enable sampled requests"
  default     = true
}