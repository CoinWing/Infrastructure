resource "aws_sns_topic_subscription" "lambda_sub" {
  topic_arn = aws_sns_topic.rds_event_sns.arn
  protocol  = "lambda"
  endpoint  = var.lambda_function
}