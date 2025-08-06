# PUBLIC ROUTE TABLE
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-${var.env}-public-rt"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

# PRIVATE ROUTE TABLE
# resource "aws_route_table" "private_nat_rt" {
#   vpc_id = aws_vpc.prod.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     network_interface_id = aws_network_interface.nat_eni.id # NAT Instance의 ENI ID
#   }

#   tags = { 
#     Name = "${var.project_name}-${var.env}-private-nat-rt" 
#   }
# }

# resource "aws_route_table_association" "eks_workers_nat_rt_association" {
#   for_each = aws_subnet.eks_worker_subnets

#   subnet_id      = each.value.id
#   route_table_id = aws_route_table.private_nat_rt.id
# }