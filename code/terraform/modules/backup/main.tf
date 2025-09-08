locals {
  common_tags = merge({
    Project = var.project_name
    Env     = var.env
  }, var.tags)
}

resource "aws_backup_vault" "this" {
  name = coalesce(var.vault_name, "${var.project_name}-${var.env}-backup-vault")

  tags = local.common_tags
}

resource "aws_backup_plan" "this" {
  name = coalesce(var.plan_name, "${var.project_name}-${var.env}-backup-plan")

  dynamic "rule" {
    for_each = var.rule_daily_enabled ? [1] : []
    content {
      rule_name         = "daily"
      target_vault_name = aws_backup_vault.this.name
      schedule          = var.rule_daily_schedule
      start_window      = var.start_window_minutes
      completion_window = var.completion_window_minutes

      lifecycle {
        delete_after = var.daily_delete_after_days
      }
    }
  }

  dynamic "rule" {
    for_each = var.rule_weekly_enabled ? [1] : []
    content {
      rule_name         = "weekly"
      target_vault_name = aws_backup_vault.this.name
      schedule          = var.rule_weekly_schedule
      start_window      = var.start_window_minutes
      completion_window = var.completion_window_minutes

      lifecycle {
        delete_after = var.weekly_delete_after_days
      }
    }
  }

  tags = local.common_tags
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = coalesce(var.role_name, "${var.project_name}-${var.env}-backup-role")
  assume_role_policy = data.aws_iam_policy_document.assume.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "service" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role_policy_attachment" "restore" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}

resource "aws_backup_selection" "by_tag" {
  count       = var.enable_tag_based_selection ? 1 : 0
  iam_role_arn = aws_iam_role.this.arn
  name         = "tag-selection"
  plan_id      = aws_backup_plan.this.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = var.selection_tag_key
    value = var.selection_tag_value
  }
}

resource "aws_backup_selection" "by_arn" {
  count        = length(var.resources) > 0 ? 1 : 0
  iam_role_arn = aws_iam_role.this.arn
  name         = "arn-selection"
  plan_id      = aws_backup_plan.this.id
  resources    = var.resources
}
