resource "aws_db_parameter_group" "cowing_db_parameter_group" {
  name        = "${var.project_name}-${var.env}-db-parameter-group"
  description = "cowing parameter group"
  family      = var.rds_parameter_group_family

  parameter {
    apply_method = "immediate"
    name         = "max_connections"
    value        = "300"
  }

  skip_destroy = "false"
}
