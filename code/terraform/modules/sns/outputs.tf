output "rds_event_sns" {
  value = aws_sns_topic.rds_event_sns.arn
}