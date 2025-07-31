# store the output
output "vpc_id" {
  value       = join("", aws_vpc.default[*].id)
  description = "The ID of the VPC created"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "The IDs of the public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "The IDs of the private subnets"
}

output "security_group_id" {
  value       = aws_security_group.default-sg.id
  description = "The security group IDs of the VPC"
}
