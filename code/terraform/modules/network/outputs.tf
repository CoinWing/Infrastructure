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