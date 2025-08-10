resource "aws_db_subnet_group" "cowing_db_subnet_group" {
  description = "RDS DB subnet group"
  name        = "${var.project_name}-${var.env}-db-subnet-group"
  subnet_ids  = var.rds_db_subnet_ids
}