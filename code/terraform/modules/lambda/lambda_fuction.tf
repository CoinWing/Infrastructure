resource "aws_lambda_function" "sns_sub_lambda" {
  function_name = "rds-events-lambda"
  handler       = "index.handler"
  runtime       = "nodejs22.x"
  role          = var.lambda_exec_role_arn

  filename         = "lambda.zip"
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      webhook = var.webhook
    }
  }
}