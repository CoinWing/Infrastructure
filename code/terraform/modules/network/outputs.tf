output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = values(aws_subnet.public_subnets)[*].id
}

output "nat_instance_subnet_id" {
  description = "ID of the NAT instance subnet"
  value       = values(aws_subnet.public_subnets)[0].id
}

output "nat_instance_security_group_id" {
  description = "ID of the NAT instance security group"
  value       = aws_security_group.nat_sg.id
}

output "bastion_subnet_id" {
  description = "Bastion subnet ID"
  value       = aws_subnet.bastion_subnet.id
}

output "bastion_vpce_security_group_id" {
  description = "Bastion VPC Endpoint security group ID"
  value       = aws_security_group.bastion_vpce.id
}

output "bastion_host_security_group_id" {
  description = "Bastion host security group ID"
  value       = aws_security_group.bastion_host.id
}

output "eks_worker_subnet_ids" {
  description = "EKS worker subnet IDs"
  value       = values(aws_subnet.eks_worker_subnets)[*].id
}

output "eks_control_plane_security_group_id" {
  description = "EKS control plane security group ID"
  value       = aws_security_group.eks_control_plane.id
}

output "rds_db_subnet_ids" {
  description = "RDS DB subnet IDs"
  value       = values(aws_subnet.rds_subnets)[*].id
}

output "rds_security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.eks_to_rds_sg.id
}