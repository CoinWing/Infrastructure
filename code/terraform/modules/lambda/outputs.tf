output "sns_sub_lambda" {
  description = "Bastion host role ARN"
  value       = aws_lambda_function.sns_sub_lambda.arn
}

