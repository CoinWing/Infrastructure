resource "aws_eip" "nat_eip" {
  domain = "vpc"
  
  tags = {
    Name = "${var.project_name}-${var.env}-nat-eip"
  }
}

resource "aws_eip_association" "nat_eip_assoc" {
  allocation_id        = aws_eip.nat_eip.id
  network_interface_id = var.nat_instance_eni_id
}