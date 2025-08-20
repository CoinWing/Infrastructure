output "table_name" {
  value = aws_dynamodb_table.this.name
}

output "arn" {
  value = aws_dynamodb_table.this.arn
}
