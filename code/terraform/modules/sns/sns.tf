resource "aws_sns_topic" "rds_event_sns" {
  name = "rds-events-sns"

  tags = {
    Name = "${var.project_name}-${var.env}-rds-events-sns"
  }
}