# Output the endpoint of the RDS instance
output "rds_endpoint" {
  description = "The endpoint of the RDS instance."
  value       = aws_db_instance.MasterDb.endpoint
}

# Output the RDS instance identifier
output "rds_instance_identifier" {
  description = "The identifier of the RDS instance."
  value       = aws_db_instance.MasterDb.id
}
