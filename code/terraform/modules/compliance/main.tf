# S3 bucket for AWS Config
resource "aws_s3_bucket" "config_bucket" {
  bucket = "${var.project_name}-${var.env}-config-bucket"

  tags = {
    Name        = "${var.project_name}-${var.env}-config-bucket"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "config_bucket" {
  bucket = aws_s3_bucket.config_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config_bucket" {
  bucket = aws_s3_bucket.config_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "config_bucket" {
  bucket = aws_s3_bucket.config_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket for CloudTrail
resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "${var.project_name}-${var.env}-cloudtrail-bucket"

  tags = {
    Name        = "${var.project_name}-${var.env}-cloudtrail-bucket"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket policy for CloudTrail
resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail_bucket.arn
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudtrail:${var.region}:${data.aws_caller_identity.current.account_id}:trail/${var.project_name}-${var.env}-cloudtrail"
          }
        }
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudtrail:${var.region}:${data.aws_caller_identity.current.account_id}:trail/${var.project_name}-${var.env}-cloudtrail"
            "s3:x-amz-acl"  = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# Data source for current account ID
data "aws_caller_identity" "current" {}

# AWS Config Configuration Recorder
resource "aws_config_configuration_recorder" "main" {
  name     = "${var.project_name}-${var.env}-config-recorder"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }

  depends_on = [aws_config_delivery_channel.main]
}

# AWS Config Delivery Channel
resource "aws_config_delivery_channel" "main" {
  name           = "${var.project_name}-${var.env}-config-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config_bucket.bucket
  s3_key_prefix  = "config"
  s3_kms_key_arn = aws_kms_key.config_key.arn

  sns_topic_arn = aws_sns_topic.config_topic.arn

  depends_on = [aws_config_configuration_recorder.main]
}

# AWS Config Rules
resource "aws_config_config_rule" "s3_bucket_public_read_prohibited" {
  name = "s3-bucket-public-read-prohibited"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

resource "aws_config_config_rule" "s3_bucket_public_write_prohibited" {
  name = "s3-bucket-public-write-prohibited"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

resource "aws_config_config_rule" "s3_bucket_ssl_requests_only" {
  name = "s3-bucket-ssl-requests-only"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SSL_REQUESTS_ONLY"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

resource "aws_config_config_rule" "rds_storage_encrypted" {
  name = "rds-storage-encrypted"

  source {
    owner             = "AWS"
    source_identifier = "RDS_STORAGE_ENCRYPTED"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

resource "aws_config_config_rule" "rds_instance_public_access_check" {
  name = "rds-instance-public-access-check"

  source {
    owner             = "AWS"
    source_identifier = "RDS_INSTANCE_PUBLIC_ACCESS_CHECK"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

resource "aws_config_config_rule" "ec2_ebs_optimized_instance" {
  name = "ec2-ebs-optimized-instance"

  source {
    owner             = "AWS"
    source_identifier = "EC2_EBS_OPTIMIZED_INSTANCE"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

resource "aws_config_config_rule" "ec2_instance_managed_by_systems_manager" {
  name = "ec2-instance-managed-by-systems-manager"

  source {
    owner             = "AWS"
    source_identifier = "EC2_INSTANCE_MANAGED_BY_SSM"
  }

  depends_on = [aws_config_configuration_recorder.main]
}

# CloudTrail
resource "aws_cloudtrail" "main" {
  name                          = "${var.project_name}-${var.env}-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.bucket
  s3_key_prefix                 = "cloudtrail"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  event_selector {
    read_write_type                 = "All"
    include_management_events       = true
    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

  event_selector {
    read_write_type                 = "All"
    include_management_events       = true
    data_resource {
      type   = "AWS::DynamoDB::Table"
      values = ["arn:aws:dynamodb:::"]
    }
  }

  event_selector {
    read_write_type                 = "All"
    include_management_events       = true
    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda:::"]
    }
  }

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_log_group.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_role.arn

  tags = {
    Name        = "${var.project_name}-${var.env}-cloudtrail"
    Environment = var.env
    Project     = var.project_name
  }
}

# Security Hub
resource "aws_securityhub_account" "main" {
  enable_default_standards = true
}

# Security Hub Standards Subscriptions
resource "aws_securityhub_standards_subscription" "cis" {
  count         = var.enable_cis_standard ? 1 : 0
  standards_arn = "arn:aws:securityhub:${var.region}::standards/cis-aws-foundations-benchmark/v/1.2.0"

  depends_on = [aws_securityhub_account.main]
}

resource "aws_securityhub_standards_subscription" "pci" {
  count         = var.enable_pci_standard ? 1 : 0
  standards_arn = "arn:aws:securityhub:${var.region}::standards/pci-dss/v/3.2.1"

  depends_on = [aws_securityhub_account.main]
}

resource "aws_securityhub_standards_subscription" "nist" {
  count         = var.enable_nist_standard ? 1 : 0
  standards_arn = "arn:aws:securityhub:${var.region}::standards/nist-cybersecurity-framework/v/1.0.0"

  depends_on = [aws_securityhub_account.main]
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name              = "/aws/cloudtrail/${var.project_name}-${var.env}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-${var.env}-cloudtrail-logs"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_cloudwatch_log_group" "config_log_group" {
  name              = "/aws/config/${var.project_name}-${var.env}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-${var.env}-config-logs"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_cloudwatch_log_group" "security_hub_log_group" {
  name              = "/aws/securityhub/${var.project_name}-${var.env}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-${var.env}-securityhub-logs"
    Environment = var.env
    Project     = var.project_name
  }
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "config_compliance_alarm" {
  alarm_name          = "${var.project_name}-${var.env}-config-compliance"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ComplianceByConfigRule"
  namespace           = "AWS/Config"
  period              = "300"
  statistic           = "Average"
  threshold           = "0"
  alarm_description   = "This metric monitors config compliance"
  alarm_actions       = [aws_sns_topic.compliance_alerts.arn]

  dimensions = {
    ConfigRuleName = "s3-bucket-public-read-prohibited"
  }
}

resource "aws_cloudwatch_metric_alarm" "security_hub_findings_alarm" {
  alarm_name          = "${var.project_name}-${var.env}-security-hub-findings"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Findings"
  namespace           = "AWS/SecurityHub"
  period              = "300"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "This metric monitors security hub findings"
  alarm_actions       = [aws_sns_topic.compliance_alerts.arn]
}

# SNS Topics
resource "aws_sns_topic" "config_topic" {
  name = "${var.project_name}-${var.env}-config-topic"

  tags = {
    Name        = "${var.project_name}-${var.env}-config-topic"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_sns_topic" "compliance_alerts" {
  name = "${var.project_name}-${var.env}-compliance-alerts"

  tags = {
    Name        = "${var.project_name}-${var.env}-compliance-alerts"
    Environment = var.env
    Project     = var.project_name
  }
}

# SNS Topic Subscriptions
resource "aws_sns_topic_subscription" "compliance_email" {
  count     = var.compliance_email != null ? 1 : 0
  topic_arn = aws_sns_topic.compliance_alerts.arn
  protocol  = "email"
  endpoint  = var.compliance_email
}

resource "aws_sns_topic_subscription" "compliance_lambda" {
  count     = var.compliance_lambda_arn != null ? 1 : 0
  topic_arn = aws_sns_topic.compliance_alerts.arn
  protocol  = "lambda"
  endpoint  = var.compliance_lambda_arn
}

# KMS Keys
resource "aws_kms_key" "config_key" {
  description             = "KMS key for AWS Config"
  deletion_window_in_days = 7

  tags = {
    Name        = "${var.project_name}-${var.env}-config-key"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_kms_key" "cloudtrail_key" {
  description             = "KMS key for CloudTrail"
  deletion_window_in_days = 7

  tags = {
    Name        = "${var.project_name}-${var.env}-cloudtrail-key"
    Environment = var.env
    Project     = var.project_name
  }
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "compliance_dashboard" {
  dashboard_name = "${var.project_name}-${var.env}-compliance-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/Config", "ComplianceByConfigRule", "ConfigRuleName", "s3-bucket-public-read-prohibited"],
            [".", ".", ".", "s3-bucket-public-write-prohibited"],
            [".", ".", ".", "s3-bucket-ssl-requests-only"],
            [".", ".", ".", "rds-storage-encrypted"],
            [".", ".", ".", "rds-instance-public-access-check"]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Config Compliance Status"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/SecurityHub", "Findings"],
            [".", "Insights"]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "Security Hub Findings"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/CloudTrail", "ApiCallCount"],
            [".", "ApiErrorCount"]
          ]
          view    = "timeSeries"
          stacked = false
          region  = var.region
          title   = "CloudTrail API Activity"
          period  = 300
        }
      },
      {
        type   = "log"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          query   = "SOURCE '/aws/cloudtrail/${var.project_name}-${var.env}' | fields @timestamp, eventName, userIdentity.type, sourceIPAddress | sort @timestamp desc | limit 20"
          region  = var.region
          title   = "Recent CloudTrail Events"
        }
      }
    ]
  })
}