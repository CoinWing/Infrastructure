# Bastion + NAT Instance를 간단하게 테스트해보는 프로비저닝 코드

locals {
  test_ami_id           = "ami-12345678"
  bastion_instance_type = "t3.micro"
  nat_instance_type     = "t4g.nano"
}

resource "aws_vpc" "test" {
  count               = var.enable_ec2 ? 1 : 0
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "ec2-test-vpc" }
}

resource "aws_internet_gateway" "igw" {
  count  = var.enable_ec2 ? 1 : 0
  vpc_id = aws_vpc.test[0].id
  tags   = { Name = "ec2-test-igw" }
}

resource "aws_subnet" "public_a" {
  count                   = var.enable_ec2 ? 1 : 0
  vpc_id                  = aws_vpc.test[0].id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags                    = { Name = "ec2-test-public-a" }
}

resource "aws_subnet" "public_b" {
  count                   = var.enable_ec2 ? 1 : 0
  vpc_id                  = aws_vpc.test[0].id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags                    = { Name = "ec2-test-public-b" }
}

resource "aws_route_table" "public" {
  count  = var.enable_ec2 ? 1 : 0
  vpc_id = aws_vpc.test[0].id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
  tags = { Name = "ec2-test-public-rt" }
}

resource "aws_route_table_association" "a" {
  count          = var.enable_ec2 ? 1 : 0
  subnet_id      = aws_subnet.public_a[0].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table_association" "b" {
  count          = var.enable_ec2 ? 1 : 0
  subnet_id      = aws_subnet.public_b[0].id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_security_group" "bastion_sg" {
  count       = var.enable_ec2 ? 1 : 0
  name        = "ec2-test-bastion-sg"
  description = "Allow minimal egress"
  vpc_id      = aws_vpc.test[0].id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ec2-test-bastion-sg" }
}

resource "aws_security_group" "nat_sg" {
  count       = var.enable_ec2 ? 1 : 0
  name        = "ec2-test-nat-sg"
  description = "Allow minimal egress"
  vpc_id      = aws_vpc.test[0].id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ec2-test-nat-sg" }
}

resource "aws_instance" "nat_instance" {
  count         = var.enable_ec2 ? 1 : 0
  ami           = local.test_ami_id
  instance_type = local.nat_instance_type
  subnet_id     = aws_subnet.public_a[0].id
  vpc_security_group_ids = [aws_security_group.nat_sg[0].id]
  source_dest_check = false
  tags = { Name = "ec2-test-nat-instance" }
}

resource "aws_instance" "bastion_host" {
  count                  = var.enable_ec2 ? 1 : 0
  ami                    = local.test_ami_id
  instance_type          = local.bastion_instance_type
  subnet_id              = aws_subnet.public_b[0].id
  vpc_security_group_ids = [aws_security_group.bastion_sg[0].id]

  user_data = <<-EOT
    #!/bin/bash
    echo "bastion test" > /var/tmp/bastion.txt
  EOT

  tags = { Name = "ec2-test-bastion-host" }
}

output "nat_instance_eni_id_test" {
  value       = var.enable_ec2 ? aws_instance.nat_instance[0].primary_network_interface_id : null
}

output "bastion_host_id_test" {
  value       = var.enable_ec2 ? aws_instance.bastion_host[0].id : null
}
