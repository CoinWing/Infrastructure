output "nat_instance_eni_id" {
  description = "ID of the NAT instance ENI"
  value       = aws_network_interface.nat_eni.id
}

output "bastion_host_id" {
  description = "ID of the Bastion host"
  value       = aws_instance.bastion_host.id
}