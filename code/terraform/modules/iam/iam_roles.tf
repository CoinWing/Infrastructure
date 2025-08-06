# IAM Role for Bastion Host
resource "aws_iam_role" "bastion_host" {
  name_prefix = "${var.project_name}-${var.env}-bastion-host"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-${var.env}-bastion-host-role"
  }
}

resource "aws_iam_role_policy_attachment" "bastion_host_ssm" {
  role       = aws_iam_role.bastion_host.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}