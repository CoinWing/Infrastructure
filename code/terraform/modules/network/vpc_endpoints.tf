# VPC Endpoints for Systems Manager
resource "aws_vpc_endpoint" "ssm" { # Systems Manager
  vpc_id              = aws_vpc.prod.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.bastion_subnet.id]
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.bastion_vpce.id]

  tags = {
    Name = "${var.project_name}-${var.env}-ssm-vpce"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" { # Systems Manager Messages
  vpc_id              = aws_vpc.prod.id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.bastion_subnet.id]
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.bastion_vpce.id]

  tags = {
    Name = "${var.project_name}-${var.env}-ssmmessages-vpce"
  }
}

resource "aws_vpc_endpoint" "ec2messages" { # EC2 Messages
  vpc_id              = aws_vpc.prod.id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.bastion_subnet.id]
  private_dns_enabled = true
  security_group_ids  = [aws_security_group.bastion_vpce.id]

  tags = {
    Name = "${var.project_name}-${var.env}-ec2messages-vpce"
  }
}