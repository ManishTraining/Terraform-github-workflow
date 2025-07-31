# store the output
output "instance_id" {
  value       = aws_instance.ec2[*].id
  description = "Instance IDs"
}
output "private_ip" {
  value       = aws_instance.ec2[*].private_ip
  description = "Private IPs of each instance"
}
