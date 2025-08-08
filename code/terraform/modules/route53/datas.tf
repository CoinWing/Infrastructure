data "aws_lb" "alb" {
  tags = {
    "elbv2.k8s.aws/cluster" = var.cluster_name
    "service.k8s.aws/stack" = "istio-system/istio-ingressgateway"
  }
}