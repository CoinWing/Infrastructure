module "network" {
  source = "../modules/network"

  project_name = var.project_name
  env = var.env
  region = var.region
  vpc_main_subnet = var.vpc_main_subnet
  public_subnets = local.public_subnets
  bastion_subnet = local.bastion_subnet
  nat_instance_subnet = local.nat_instance_subnet
  rds_subnets = local.rds_subnets
  eks_worker_subnets = local.eks_worker_subnets
  availability_zones = var.availability_zones
  nat_instance_eni_id = module.ec2.nat_instance_eni_id
  rds_port = var.rds_port
}

module "ec2" {
  source = "../modules/ec2"

  project_name = var.project_name
  env = var.env
  region = var.region
  nat_instance_subnet_id = module.network.nat_instance_subnet_id
  nat_security_group_id = module.network.nat_instance_security_group_id
  bastion_instance_type = var.bastion_instance_type
  bastion_subnet_id = module.network.bastion_subnet_id
  bastion_security_group_id = module.network.bastion_host_security_group_id
  bastion_instance_profile_name = module.iam.bastion_instance_profile_name
}

module "iam" {
  source = "../modules/iam"

  project_name = var.project_name
  env = var.env
}

module "s3" {
  source = "../modules/s3"

  project_name = var.project_name
  env = var.env
}

module "dynamodb" {
  source = "../modules/dynamodb"

  project_name = var.project_name
  env = var.env
}

module "eks" {
  source = "../modules/eks"

  # cluster variables
  project_name = var.project_name
  env = var.env
  region = var.region
  cluster_version = var.cluster_version
  cluster_role_arn = module.iam.eks_cluster_role_arn
  cluster_name = "${var.project_name}-${var.env}-eks"
  eks_worker_subnet_ids = module.network.eks_worker_subnet_ids
  bastion_host_id = module.ec2.bastion_host_id
  eks_control_plane_security_group_id = module.network.eks_control_plane_security_group_id
  bastion_host_role_arn = module.iam.bastion_host_role_arn

  # launch template variables
  eks_worker_ng_lt_image_id = var.launch_template_image_id
  eks_worker_ng_lt_instance_type = var.node_group_instance_type

  # node group variables
  eks_worker_ng_role_arn = module.iam.eks_worker_ng_role_arn
  eks_worker_ng_subnet_ids = module.network.eks_worker_subnet_ids
  eks_worker_ng_name = "${var.project_name}-${var.env}-eks-worker-ng"
  eks_worker_ng_lt_id = module.eks.eks_worker_ng_lt_id
  eks_worker_ng_desired_size = var.node_group_desired_size
  eks_worker_ng_min_size = var.node_group_min_size
  eks_worker_ng_max_size = var.node_group_max_size
}

module "route53_zone" {
  source = "../modules/route53-zone"

  project_name = var.project_name
  env = var.env
  domain_name = var.domain_name
}

module "route53_records" {
  source = "../modules/route53-records"

  domain_name = var.domain_name
  cluster_name = "${var.project_name}-${var.env}-eks"
  cowing_co_kr_zone_id = module.route53_zone.cowing_co_kr_zone_id
}

module "acm" {
  source = "../modules/acm"

  project_name = var.project_name
  env = var.env
  domain_name = var.domain_name
  cowing_co_kr_zone_id = module.route53_zone.cowing_co_kr_zone_id
}

module "rds" {
  source = "../modules/rds"

  project_name = var.project_name
  env = var.env
  rds_port = var.rds_port
  rds_db_name = var.rds_db_name
  rds_engine = var.rds_engine
  rds_engine_version = var.rds_engine_version
  rds_instance_type = var.rds_instance_type
  rds_username = var.rds_username
  rds_password = var.rds_password  
  rds_security_group_id = module.network.rds_security_group_id
  rds_db_subnet_ids = module.network.rds_db_subnet_ids
  rds_parameter_group_family = var.rds_parameter_group_family
  rds_event_sns = module.sns.rds_event_sns
}

module "sqs" {
  source = "../modules/sqs"

  project_name = var.project_name
  env          = var.env
  queue_name   = "Cowing.fifo"
  fifo         = true
}

module "sns" {
  source       = "../modules/sns"
  project_name = var.project_name
  env          = var.env
  lambda_function = module.lambda.sns_sub_lambda

}

module "lambda" {
  source       = "../modules/lambda"
  project_name = var.project_name
  env          = var.env
  lambda_exec_role_arn = module.iam.lambda_exec_role_arn
  rds_event_sns = module.sns.rds_event_sns
  webhook = var.webhook
}

module "secrets_manager" {
  source = "../modules/secrets-manager"
  project_name = var.project_name
  env = var.env  
  github_username = var.github_username
  github_password = var.github_password
  github_email = var.github_email
  jwt_secret = var.jwt_secret
  mariadb_username = var.rds_username
  mariadb_password = var.rds_password
  redis_password = var.redis_password
  queue_name = var.queue_name
  pd_redis_password = var.pd_redis_password
  access_key = var.access_key
  secret_key = var.secret_key
  sqs_uri = var.sqs_uri
}

module "waf" {
  source = "../modules/waf"

  project_name = var.project_name
  env          = var.env
  scope        = "REGIONAL"  # For ALB, use "CLOUDFRONT" for CloudFront

  # Enable AWS Managed Rules
  enable_core_rule_set      = true
  enable_known_bad_inputs   = true
  enable_sql_injection      = true
  enable_linux_os          = true

  # Rate limiting
  enable_rate_limiting = true
  rate_limit          = 2000

  # Geo blocking (optional)
  blocked_countries = []

  # IP blocking (optional)
  create_ip_set         = true
  blocked_ip_addresses  = []

  # Logging
  enable_logging      = true
  log_retention_days  = 14

  # Monitoring
  cloudwatch_metrics_enabled = true
  sampled_requests_enabled   = true
}

module "cloudfront" {
  source = "../modules/cloudfront"

  project_name    = var.project_name
  env             = var.env
  domain_aliases  = [var.domain_name, "www.${var.domain_name}"]
  certificate_arn = module.acm.certificate_arn
  
  # ALB domain for API requests (if you have ALB)
  alb_domain_name = "api.${var.domain_name}"
  
  # Route53 configuration
  route53_zone_id        = module.route53_zone.cowing_co_kr_zone_id
  create_route53_record  = true
  
  # Cache settings
  cache_min_ttl     = 0
  cache_default_ttl = 3600
  cache_max_ttl     = 86400
  
  # Price class (adjust based on your needs)
  price_class = "PriceClass_100"  # US, Canada, Europe
  
  # Custom error responses for SPA
  custom_error_responses = [
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    },
    {
      error_code         = 403
      response_code      = 200
      response_page_path = "/index.html"
    }
  ]
}

module "backup" {
  source       = "../modules/backup"
  project_name = var.project_name
  env          = var.env
  rule_weekly_enabled = true
}
