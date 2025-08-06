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
}