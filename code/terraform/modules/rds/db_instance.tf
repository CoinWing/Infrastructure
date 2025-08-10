resource "aws_db_instance" "cowing_db" {
  identifier = "${var.project_name}-${var.env}-rds"
  port = var.rds_port
  db_name              = var.rds_db_name
  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  instance_class       = var.rds_instance_type
  username             = var.rds_username
  password             = var.rds_password
  vpc_security_group_ids = [var.rds_security_group_id]

  parameter_group_name = aws_db_parameter_group.cowing_db_parameter_group.name
  db_subnet_group_name = aws_db_subnet_group.cowing_db_subnet_group.name

  multi_az = "false"
  publicly_accessible = "false"

  allocated_storage = "10"
  storage_type = "gp2"
  storage_encrypted = "true"
  storage_throughput = "0"
}