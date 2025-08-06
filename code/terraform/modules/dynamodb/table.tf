resource "aws_dynamodb_table" "terraform_locks" {
  name           = "${var.project_name}-${var.env}-terraform-state-locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}-${var.env}-terraform-state-locks"
  }
}