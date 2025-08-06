resource "aws_network_interface" "nat_eni" {
  subnet_id       = var.nat_instance_subnet_id
  security_groups = [var.nat_security_group_id]

  source_dest_check = false
}

resource "aws_instance" "nat_instance" {                                                   
  ami           = data.aws_ami.fck_nat.id
  instance_type = "t4g.nano"

  network_interface {
    network_interface_id = aws_network_interface.nat_eni.id
    device_index         = 0
  }                                                                              

  tags = {
    Name = "${var.project_name}-${var.env}-nat-instance"
  }
}