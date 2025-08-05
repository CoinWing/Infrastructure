resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name = "${var.project_name}-${var.env}-igw"
  }
}