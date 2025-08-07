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

  project_name = var.project_name
  env = var.env
  region = var.region
  cluster_version = var.cluster_version
  # node_group_instance_types = var.node_group_instance_types
  # node_group_desired_size = var.node_group_desired_size
  # node_group_min_size = var.node_group_min_size
  # node_group_max_size = var.node_group_max_size
  cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_worker_subnet_ids = module.network.eks_worker_subnet_ids
  bastion_host_id = module.ec2.bastion_host_id
}