resource "aws_security_group" "nat_sg" {
  name        = "${var.project_name}-${var.env}-nat-sg"
  description = "Security group for NAT instance"
  vpc_id      = aws_vpc.prod.id

  # Private subnet 중 EKS Worker Subnet에서 오는 트래픽 허용
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.eks_worker_subnets
  }

  # NAT instance에서 인터넷으로 나가는 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.env}-nat-sg"
  }
}