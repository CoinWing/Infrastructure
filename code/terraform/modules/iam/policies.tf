# ALB Ingress Controller IAM Policy
resource "aws_iam_policy" "aws_load_balancer_controller_iam_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/alb_controller_policy.json")
}

# External Secret IAM Policy
resource "aws_iam_policy" "external_secret_policy" {
  name        = "ExternalSecretPolicy"
  description = "IAM policy for External Secret"
  policy      = file("${path.module}/external_secret_policy.json")
}