resource "aws_sns_topic" "rds_event_sns" {
  name = "rds-events-sns"
}