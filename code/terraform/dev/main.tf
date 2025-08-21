locals {
  project_name = "cowing"
  env          = "dev"
}


module "s3" {
  source       = "../modules/s3"
  project_name = local.project_name
  env          = local.env
}

module "dynamodb" {
  source       = "../modules/dynamodb"
  project_name = local.project_name
  env          = local.env
}

module "sqs" {
  source       = "../modules/sqs"
  project_name = local.project_name
  env          = local.env
  queue_name   = "${local.project_name}-${local.env}-sqs"

  fifo                         = true
  content_based_deduplication = false
  visibility_timeout_seconds   = 30
  message_retention_seconds    = 18000
  delay_seconds                = 0
  max_message_size             = 1024
  receive_wait_time_seconds    = 5
}

module "iam" {
  source       = "../modules/iam"
  project_name = local.project_name
  env          = local.env
}

# Minimal network just for EC2 module testing (kept local to dev)
resource "aws_vpc" "dev" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "${local.project_name}-${local.env}-vpc" }
}

resource "aws_subnet" "dev_public" {
  vpc_id                  = aws_vpc.dev.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = { Name = "${local.project_name}-${local.env}-public-1" }
}

resource "aws_security_group" "nat_sg" {
  name        = "${local.project_name}-${local.env}-nat-sg-dev"
  description = "NAT instance SG (dev)"
  vpc_id      = aws_vpc.dev.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.project_name}-${local.env}-nat-sg-dev" }
}

resource "aws_security_group" "bastion_sg" {
  name        = "${local.project_name}-${local.env}-bastion-sg-dev"
  description = "Bastion host SG (dev)"
  vpc_id      = aws_vpc.dev.id

  # Optional: allow SSH for realism (not required by LocalStack)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.project_name}-${local.env}-bastion-sg-dev" }
}
