resource "aws_vpc" "prod" {
  cidr_block       = var.vpc_main_subnet
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-${var.env}-vpc"
  }
}