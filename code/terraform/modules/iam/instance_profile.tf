# IAM Instance Profile for Bastion Host
resource "aws_iam_instance_profile" "bastion_host" {
  name_prefix = "${var.project_name}-${var.env}-bastion-host"
  role        = aws_iam_role.bastion_host.name

  tags = {
    Name = "${var.project_name}-${var.env}-bastion-host-profile"
  }
}