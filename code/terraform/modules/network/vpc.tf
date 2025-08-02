resource "aws_vpc" "prod" {
  cidr_block       = var.vpc_main_subnet
  instance_tenancy = "default"

  tags = {
    Name = "${var.project_name}-${var.env}-vpc"
  }
}