output "vault_name" {
  description = "Name of the AWS Backup vault"
  value       = aws_backup_vault.this.name
}

output "vault_arn" {
  description = "ARN of the AWS Backup vault"
  value       = aws_backup_vault.this.arn
}

output "plan_id" {
  description = "ID of the AWS Backup plan"
  value       = aws_backup_plan.this.id
}

output "plan_arn" {
  description = "ARN of the AWS Backup plan"
  value       = aws_backup_plan.this.arn
}

output "role_arn" {
  description = "ARN of the IAM role used by AWS Backup"
  value       = aws_iam_role.this.arn
}

output "tag_selection_id" {
  description = "ID of the tag-based backup selection (if created)"
  value       = try(aws_backup_selection.by_tag[0].id, null)
}

output "arn_selection_id" {
  description = "ID of the ARN-based backup selection (if created)"
  value       = try(aws_backup_selection.by_arn[0].id, null)
}
