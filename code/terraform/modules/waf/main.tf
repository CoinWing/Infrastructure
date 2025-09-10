# WAF Web ACL
resource "aws_wafv2_web_acl" "main" {
  name  = "${var.project_name}-${var.env}-waf"
  scope = var.scope

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }
    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  # AWS Managed Rules - Core Rule Set
  dynamic "rule" {
    for_each = var.enable_core_rule_set ? [1] : []
    content {
      name     = "AWSManagedRulesCommonRuleSet"
      priority = 1

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesCommonRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                 = "CommonRuleSetMetric"
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  # AWS Managed Rules - Known Bad Inputs
  dynamic "rule" {
    for_each = var.enable_known_bad_inputs ? [1] : []
    content {
      name     = "AWSManagedRulesKnownBadInputsRuleSet"
      priority = 2

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesKnownBadInputsRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                 = "KnownBadInputsRuleSetMetric"
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  # AWS Managed Rules - SQL Injection
  dynamic "rule" {
    for_each = var.enable_sql_injection ? [1] : []
    content {
      name     = "AWSManagedRulesSQLiRuleSet"
      priority = 3

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesSQLiRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                 = "SQLiRuleSetMetric"
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  # AWS Managed Rules - Linux Operating System
  dynamic "rule" {
    for_each = var.enable_linux_os ? [1] : []
    content {
      name     = "AWSManagedRulesLinuxOperatingSystemRuleSet"
      priority = 4

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesLinuxOperatingSystemRuleSet"
          vendor_name = "AWS"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                 = "LinuxOSRuleSetMetric"
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  # Rate Limiting Rule
  dynamic "rule" {
    for_each = var.enable_rate_limiting ? [1] : []
    content {
      name     = "RateLimitRule"
      priority = 5

      action {
        block {}
      }

      statement {
        rate_based_statement {
          limit              = var.rate_limit
          aggregate_key_type = "IP"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                 = "RateLimitMetric"
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  # Geo Blocking Rule
  dynamic "rule" {
    for_each = length(var.blocked_countries) > 0 ? [1] : []
    content {
      name     = "GeoBlockingRule"
      priority = 6

      action {
        block {}
      }

      statement {
        geo_match_statement {
          country_codes = var.blocked_countries
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                 = "GeoBlockingMetric"
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  # IP Set Rule
  dynamic "rule" {
    for_each = var.ip_set_arn != null ? [1] : []
    content {
      name     = "IPSetRule"
      priority = 7

      action {
        block {}
      }

      statement {
        ip_set_reference_statement {
          arn = var.ip_set_arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                 = "IPSetMetric"
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  # Custom Rules
  dynamic "rule" {
    for_each = var.custom_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      dynamic "action" {
        for_each = rule.value.action == "allow" ? [1] : []
        content {}
      }
      dynamic "action" {
        for_each = rule.value.action == "block" ? [1] : []
        content {
          block {}
        }
      }
      dynamic "action" {
        for_each = rule.value.action == "count" ? [1] : []
        content {
          count {}
        }
      }

      statement {
        dynamic "byte_match_statement" {
          for_each = rule.value.statement_type == "byte_match" ? [rule.value.byte_match] : []
          content {
            search_string         = byte_match_statement.value.search_string
            field_to_match {
              dynamic "uri_path" {
                for_each = byte_match_statement.value.field == "uri_path" ? [1] : []
                content {}
              }
              dynamic "query_string" {
                for_each = byte_match_statement.value.field == "query_string" ? [1] : []
                content {}
              }
              dynamic "body" {
                for_each = byte_match_statement.value.field == "body" ? [1] : []
                content {}
              }
              dynamic "header" {
                for_each = byte_match_statement.value.field == "header" ? [1] : []
                content {
                  name = byte_match_statement.value.header_name
                }
              }
            }
            text_transformation {
              priority = 0
              type     = byte_match_statement.value.text_transformation
            }
            positional_constraint = byte_match_statement.value.positional_constraint
          }
        }
        dynamic "geo_match_statement" {
          for_each = rule.value.statement_type == "geo_match" ? [rule.value.geo_match] : []
          content {
            country_codes = geo_match_statement.value.country_codes
          }
        }
        dynamic "ip_set_reference_statement" {
          for_each = rule.value.statement_type == "ip_set" ? [rule.value.ip_set] : []
          content {
            arn = ip_set_reference_statement.value.arn
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
        metric_name                 = rule.value.name
        sampled_requests_enabled   = var.sampled_requests_enabled
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                 = "${var.project_name}-${var.env}-waf"
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  tags = {
    Name        = "${var.project_name}-${var.env}-waf"
    Environment = var.env
    Project     = var.project_name
  }
}

# CloudWatch Log Group for WAF
resource "aws_cloudwatch_log_group" "waf_log_group" {
  count             = var.enable_logging ? 1 : 0
  name              = "/aws/wafv2/${var.project_name}-${var.env}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.project_name}-${var.env}-waf-logs"
    Environment = var.env
    Project     = var.project_name
  }
}

# WAF Logging Configuration
resource "aws_wafv2_web_acl_logging_configuration" "main" {
  count                   = var.enable_logging ? 1 : 0
  resource_arn            = aws_wafv2_web_acl.main.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf_log_group[0].arn]
}

# IP Set for custom IP blocking
resource "aws_wafv2_ip_set" "blocked_ips" {
  count       = var.create_ip_set ? 1 : 0
  name        = "${var.project_name}-${var.env}-blocked-ips"
  description = "IP addresses to block"
  scope       = var.scope
  ip_address_version = "IPV4"
  addresses   = var.blocked_ip_addresses

  tags = {
    Name        = "${var.project_name}-${var.env}-blocked-ips"
    Environment = var.env
    Project     = var.project_name
  }
}