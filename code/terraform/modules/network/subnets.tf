resource "aws_subnet" "public_subnets" {
  for_each = toset(var.public_subnets)
  
  vpc_id            = aws_vpc.prod.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[index(var.public_subnets, each.value)]

  tags = {
    Name = "${var.project_name}-${var.env}-public-${index(var.public_subnets, each.value) + 1}"
  }
}

resource "aws_subnet" "eks_worker_subnets" {
  for_each = toset(var.eks_worker_subnets)
  
  vpc_id     = aws_vpc.prod.id
  cidr_block = each.value
  availability_zone = var.availability_zones[index(var.eks_worker_subnets, each.value)]

  tags = {
    Name = "${var.project_name}-${var.env}-eks-worker-${index(var.eks_worker_subnets, each.value) + 1}"
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