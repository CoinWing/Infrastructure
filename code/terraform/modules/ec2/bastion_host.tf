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

  # aws-cli와 kubectl 설치를 위한 user_data
  user_data = base64encode(templatefile("${path.module}/bastion_host_userdata.sh", {
    region       = var.region
    project_name = var.project_name
    env          = var.env
  }))

  tags = {
    Name = "${var.project_name}-${var.env}-bastion-host"
  }
}