# AWS Config
output "config_configuration_recorder_name" {
  description = "AWS Config Configuration Recorder name"
  value       = aws_config_configuration_recorder.main.name
}

output "config_delivery_channel_name" {
  description = "AWS Config Delivery Channel name"
  value       = aws_config_delivery_channel.main.name
}

output "config_bucket_name" {
  description = "S3 bucket name for AWS Config"
  value       = aws_s3_bucket.config_bucket.bucket
}

output "config_bucket_arn" {
  description = "S3 bucket ARN for AWS Config"
  value       = aws_s3_bucket.config_bucket.arn
}

# CloudTrail
output "cloudtrail_name" {
  description = "CloudTrail name"
  value       = aws_cloudtrail.main.name
}

output "cloudtrail_arn" {
  description = "CloudTrail ARN"
  value       = aws_cloudtrail.main.arn
}

output "cloudtrail_bucket_name" {
  description = "S3 bucket name for CloudTrail"
  value       = aws_s3_bucket.cloudtrail_bucket.bucket
}

output "cloudtrail_bucket_arn" {
  description = "S3 bucket ARN for CloudTrail"
  value       = aws_s3_bucket.cloudtrail_bucket.arn
}

# Security Hub
output "security_hub_arn" {
  description = "Security Hub ARN"
  value       = aws_securityhub_account.main.arn
}

# CloudWatch
output "cloudtrail_log_group_name" {
  description = "CloudTrail log group name"
  value       = aws_cloudwatch_log_group.cloudtrail_log_group.name
}

output "config_log_group_name" {
  description = "Config log group name"
  value       = aws_cloudwatch_log_group.config_log_group.name
}

output "security_hub_log_group_name" {
  description = "Security Hub log group name"
  value       = aws_cloudwatch_log_group.security_hub_log_group.name
}

output "compliance_dashboard_url" {
  description = "CloudWatch compliance dashboard URL"
  value       = "https://${var.region}.console.aws.amazon.com/cloudwatch/home?region=${var.region}#dashboards:name=${aws_cloudwatch_dashboard.compliance_dashboard.dashboard_name}"
}

# SNS
output "compliance_alerts_topic_arn" {
  description = "SNS topic ARN for compliance alerts"
  value       = aws_sns_topic.compliance_alerts.arn
}

output "config_topic_arn" {
  description = "SNS topic ARN for config notifications"
  value       = aws_sns_topic.config_topic.arn
}

# KMS
output "config_key_arn" {
  description = "KMS key ARN for AWS Config"
  value       = aws_kms_key.config_key.arn
}

output "cloudtrail_key_arn" {
  description = "KMS key ARN for CloudTrail"
  value       = aws_kms_key.cloudtrail_key.arn
}
