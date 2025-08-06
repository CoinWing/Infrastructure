# Bastion Host EC2 Instance
resource "aws_instance" "bastion_host" {
  ami                     = data.aws_ami.amazon_linux_2.id
  instance_type           = var.bastion_instance_type
  subnet_id               = var.bastion_subnet_id
  vpc_security_group_ids  = [var.bastion_security_group_id]
  iam_instance_profile    = var.bastion_instance_profile_name
  disable_api_termination = true

  root_block_device {
    encrypted = true
  }

  monitoring = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "${var.project_name}-${var.env}-bastion-host"
  }
}