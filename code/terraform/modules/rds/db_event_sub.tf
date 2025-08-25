resource "aws_db_event_subscription" "db_sub" {
  name      = "rds-event-sub"
  sns_topic = var.rds_event_sns

  source_type = "db-instance"
}
