output "replication_group_id" {
  description = "ID of the ElastiCache replication group"
  value       = module.redis.replication_group_id
}

output "replication_group_arn" {
  description = "ARN of the replication group"
  value       = module.redis.replication_group_arn
}

output "primary_endpoint_address" {
  description = "Primary endpoint for write operations"
  value       = module.redis.replication_group_primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "Reader endpoint for read operations"
  value       = module.redis.replication_group_reader_endpoint_address
}

output "port" {
  description = "Redis port"
  value       = 6379
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for at-rest encryption"
  value       = module.redis.kms_key_arn
}

output "kms_key_alias" {
  description = "Alias of the KMS key"
  value       = module.redis.kms_key_alias
}

output "security_group_id" {
  description = "ID of the Redis security group"
  value       = module.redis.security_group_id
}

output "subnet_group_name" {
  description = "ElastiCache subnet group name"
  value       = module.redis.subnet_group_name
}

output "parameter_group_name" {
  description = "ElastiCache parameter group name"
  value       = module.redis.parameter_group_name
}

output "redis_cli_connection" {
  description = "Example redis-cli connection command"
  value       = module.redis.redis_cli_connection
}

output "connection_info" {
  description = "Connection info for applications"
  value       = module.redis.connection_info
}

output "cloudwatch_alarm_cpu_arn" {
  description = "ARN of the CPU CloudWatch alarm"
  value       = module.redis.cloudwatch_alarm_cpu_arn
}

output "cloudwatch_alarm_memory_arn" {
  description = "ARN of the memory CloudWatch alarm"
  value       = module.redis.cloudwatch_alarm_memory_arn
}
