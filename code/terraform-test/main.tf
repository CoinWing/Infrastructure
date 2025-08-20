module "dynamodb" {
  source       = "./modules/dynamodb"
  table_name   = var.dynamodb_table_name
  hash_key     = var.dynamodb_hash_key
  billing_mode = "PAY_PER_REQUEST"
  pitr_enabled = true
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda_execution_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "lambda_logs_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_logs_policy" {
  policy      = data.aws_iam_policy_document.lambda_logs_policy.json
  name        = "lambda_logs_policy"
  description = "Policy to allow Lambda to write logs to CloudWatch"
}

resource "aws_iam_role_policy_attachment" "lambda_logs_attachment" {
  policy_arn = aws_iam_policy.lambda_logs_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

module "lambda" {
  source = "./modules/lambda"

  function_name  = var.lambda_name
  role_arn       = aws_iam_role.lambda_execution_role.arn
  handler        = "index.lambda_handler"
  runtime        = "python3.8"
  zip_source_dir = "${path.module}/lambda/"
  zip_path       = "${path.module}/lambda/lambda-trigger-sm.zip"
  timeout        = 120
}

module "sqs" {
  source = "./modules/sqs"

  name                        = "cowing-test.fifo"
  fifo_queue                  = true
  content_based_deduplication = false
  visibility_timeout_seconds  = 30
  message_retention_seconds   = 18000
  delay_seconds               = 0
  max_message_size            = 1024
  receive_wait_time_seconds   = 5
}
