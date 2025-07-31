output "elasticache_cluster_id" {
  description = "The ID of the ElastiCache cluster"
  value       = aws_elasticache_cluster.redis-cluster.id
}

output "subnet_group_name" {
  description = "The name of the ElastiCache subnet group"
  value       = aws_elasticache_subnet_group.redis-sb-grp.name
}
