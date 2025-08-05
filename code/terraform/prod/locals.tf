locals {
  # PUBLIC SUBNETS
  public_subnets = [
    cidrsubnet(var.vpc_main_subnet, 8, 0), # x.x.0.0/24
    cidrsubnet(var.vpc_main_subnet, 8, 1), # x.x.1.0/24
    cidrsubnet(var.vpc_main_subnet, 8, 2), # x.x.2.0/24
  ]
  bastion_subnet = cidrsubnet(var.vpc_main_subnet, 8, 0) # x.x.0.0/24
  nat_instance_subnet = cidrsubnet(var.vpc_main_subnet, 8, 1) # x.x.1.0/24

  # PRIVATE SUBNETS
  eks_worker_subnets = [
    cidrsubnet(var.vpc_main_subnet, 8, 3), # x.x.3.0/24
    cidrsubnet(var.vpc_main_subnet, 8, 4), # x.x.4.0/24
    cidrsubnet(var.vpc_main_subnet, 8, 5), # x.x.5.0/24
  ]
  rds_subnets = [
    cidrsubnet(var.vpc_main_subnet, 8, 6), # x.x.6.0/24
    cidrsubnet(var.vpc_main_subnet, 8, 7), # x.x.7.0/24
  ]
}