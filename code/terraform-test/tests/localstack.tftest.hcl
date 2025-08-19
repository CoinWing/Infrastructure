provider "aws" {
  access_key = "test"
  secret_key = "test"
  region     = "ap-northeast-2"
  s3_use_path_style           = true
  skip_requesting_account_id  = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true

  endpoints {
    cloudwatch     = "http://localhost:4566"
    cloudwatchlogs = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    iam            = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}

run "check_lambda_function" {

  command = apply
  variables{
    enable_ec2 = false
  }

  assert {
    condition     = output.lambda_arn != null
    error_message = "Lambda function not created"
  }

}
 
# run "check_dynamodb_table" {
#   command = apply
#   variables{
#     enable_ec2 = false
#   }

#   assert {
#     condition     = output.dynamodb_table_name == var.dynamodb_table_name
#     error_message = "DynamoDB table not created or name mismatch"
#   }
# }

# run "check_ec2_stack" {
#   command = apply
#   variables{
#     enable_ec2 = true
#   }

#   assert {
#     condition     = output.bastion_host_id_test != null && output.nat_instance_eni_id_test != null
#     error_message = "EC2 stack (bastion/nat) not created"
#   }
# }
