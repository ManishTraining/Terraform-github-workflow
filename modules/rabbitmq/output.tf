output "RabbitMQ_arn" {
  description = "ARN of the RabbitMQ broker."
  value       = aws_mq_broker.this.arn
}

output "RabbitMQ_id" {
  description = "ID of the RabbitMQ broker."
  value       = aws_mq_broker.this.id
}

output "RabbitMQ_console_url" {
  description = "The URL of the broker's RabbitMQ Web Console"
  value       = aws_mq_broker.this.instances.0.console_url
}

output "RabbitMQ_ip_address" {
  description = "IP Address of the RabbitMQ broker"
  value       = aws_mq_broker.this.instances.0.ip_address
}

output "RabbitMQ_endpoint" {
  description = "Broker's wire-level protocol endpoint"
  value       = aws_mq_broker.this.instances.0.endpoints
}