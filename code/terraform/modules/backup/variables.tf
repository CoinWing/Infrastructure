variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "tags" {
  description = "Extra tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "vault_name" {
  description = "Backup vault name"
  type        = string
  default     = null
}

variable "plan_name" {
  description = "Backup plan name"
  type        = string
  default     = null
}

variable "rule_daily_enabled" {
  description = "Enable daily backup rule"
  type        = bool
  default     = true
}

variable "rule_weekly_enabled" {
  description = "Enable weekly backup rule"
  type        = bool
  default     = false
}

variable "rule_daily_schedule" {
  description = "AWS cron expression for daily backups (UTC)"
  type        = string
  # Every day at 03:00 UTC
  default     = "cron(0 3 * * ? *)"
}

variable "rule_weekly_schedule" {
  description = "AWS cron expression for weekly backups (UTC)"
  type        = string
  # Every Sunday at 04:00 UTC
  default     = "cron(0 4 ? * SUN *)"
}

variable "start_window_minutes" {
  description = "Amount of time in minutes after a backup is scheduled before a job is canceled if it doesn't start successfully"
  type        = number
  default     = 120
}

variable "completion_window_minutes" {
  description = "Amount of time in minutes AWS Backup attempts a backup before canceling the job"
  type        = number
  default     = 360
}

variable "daily_delete_after_days" {
  description = "Number of days before backup data is deleted for daily rule"
  type        = number
  default     = 35
}

variable "weekly_delete_after_days" {
  description = "Number of days before backup data is deleted for weekly rule"
  type        = number
  default     = 90
}

variable "resources" {
  description = "List of ARNs of resources to include explicitly in selection"
  type        = list(string)
  default     = []
}

variable "enable_tag_based_selection" {
  description = "Enable tag-based selection of resources"
  type        = bool
  default     = true
}

variable "selection_tag_key" {
  description = "Tag key to select resources for backup"
  type        = string
  default     = "backup"
}

variable "selection_tag_value" {
  description = "Tag value to select resources for backup"
  type        = string
  default     = "true"
}

variable "role_name" {
  description = "IAM role name for AWS Backup service"
  type        = string
  default     = null
}
