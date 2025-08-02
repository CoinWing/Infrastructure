module "network" {
  source = "../modules/network"

  project_name = var.project_name
  env          = var.env
  region       = var.region
  vpc_main_subnet = var.vpc_main_subnet
  public_subnets = local.public_subnets
  bastion_subnet = local.bastion_subnet
  nat_instance_subnet = local.nat_instance_subnet
  rds_subnets = local.rds_subnets
  eks_worker_subnets = local.eks_worker_subnets
}