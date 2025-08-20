data "archive_file" "package" {
  type        = "zip"
  source_dir  = var.zip_source_dir
  output_path = var.zip_path
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  role          = var.role_arn

  filename         = var.zip_path
  source_code_hash = data.archive_file.package.output_base64sha256
  timeout          = var.timeout

  tracing_config { mode = "Active" }
}

resource "aws_cloudwatch_log_group" "this" {
  retention_in_days = 1
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
}
