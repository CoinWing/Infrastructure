output "arn" {
  value = aws_lambda_function.this.arn
}

output "function_name" {
  description = "The name of the Lambda function."
  value       = aws_lambda_function.this.function_name
}

output "log_group_name" {
  description = "The name of the CloudWatch log group for the Lambda function."
  value       = aws_cloudwatch_log_group.this.name
}
