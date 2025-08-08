resource "aws_subnet" "public_subnets" {
  for_each = toset(var.public_subnets)
  
  vpc_id            = aws_vpc.prod.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[index(var.public_subnets, each.value)]

  tags = {
    Name = "${var.project_name}-${var.env}-public-${index(var.public_subnets, each.value) + 1}"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "eks_worker_subnets" {
  for_each = toset(var.eks_worker_subnets)
  
  vpc_id     = aws_vpc.prod.id
  cidr_block = each.value
  availability_zone = var.availability_zones[index(var.eks_worker_subnets, each.value)]

  tags = {
    Name = "${var.project_name}-${var.env}-eks-worker-${index(var.eks_worker_subnets, each.value) + 1}"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "rds_subnets" {
  for_each = toset(var.rds_subnets)
  
  vpc_id     = aws_vpc.prod.id
  cidr_block = each.value
  availability_zone = var.availability_zones[index(var.rds_subnets, each.value)]

  tags = {
    Name = "${var.project_name}-${var.env}-rds-${index(var.rds_subnets, each.value) + 1}"
  }
}

resource "aws_subnet" "bastion_subnet" {
  vpc_id     = aws_vpc.prod.id
  cidr_block = var.bastion_subnet
  availability_zone = var.availability_zones[2]

  tags = {
    Name = "${var.project_name}-${var.env}-bastion-private"
  }
}