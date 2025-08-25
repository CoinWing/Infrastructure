resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_sub_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.rds_event_sns
}
