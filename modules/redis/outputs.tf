# =============================================================================
# Outputs - ElastiCache Redis Module
# =============================================================================

# -----------------------------------------------------------------------------
# Replication Group Information
# -----------------------------------------------------------------------------
output "replication_group_id" {
  description = "ID of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.this.id
}

output "replication_group_arn" {
  description = "ARN of the replication group"
  value       = aws_elasticache_replication_group.this.arn
}

output "replication_group_primary_endpoint_address" {
  description = "Primary endpoint address"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "replication_group_reader_endpoint_address" {
  description = "Reader endpoint address"
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "replication_group_configuration_endpoint_address" {
  description = "Configuration endpoint (cluster mode)"
  value       = aws_elasticache_replication_group.this.configuration_endpoint_address
}

output "replication_group_member_clusters" {
  description = "Member cluster IDs"
  value       = aws_elasticache_replication_group.this.member_clusters
}

# -----------------------------------------------------------------------------
# Security Group Information
# -----------------------------------------------------------------------------
output "security_group_id" {
  description = "ID of the security group"
  value       = try(aws_security_group.this[0].id, null)
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = try(aws_security_group.this[0].arn, null)
}

# -----------------------------------------------------------------------------
# Subnet Group Information
# -----------------------------------------------------------------------------
output "subnet_group_name" {
  description = "Name of the subnet group"
  value       = try(aws_elasticache_subnet_group.this[0].name, null)
}

# -----------------------------------------------------------------------------
# Parameter Group Information
# -----------------------------------------------------------------------------
output "parameter_group_name" {
  description = "Name of the parameter group"
  value       = try(aws_elasticache_parameter_group.this[0].name, null)
}

# -----------------------------------------------------------------------------
# KMS Information
# -----------------------------------------------------------------------------
output "kms_key_id" {
  description = "KMS key ID"
  value       = local.kms_key_id
}

output "kms_key_alias" {
  value       = try(aws_kms_alias.elasticache[0].name, null)
  description = "KMS alias created for ElastiCache CMK (if created)."
}
output "kms_key_arn" {
  value       = local.kms_key_arn
  description = "KMS key ARN in use (null if AWS-managed encryption)."
}



# -----------------------------------------------------------------------------
# Connection Information
# -----------------------------------------------------------------------------
output "connection_info" {
  description = "Connection information for applications"
  value = {
    primary_endpoint = aws_elasticache_replication_group.this.primary_endpoint_address
    reader_endpoint  = aws_elasticache_replication_group.this.reader_endpoint_address
    port             = var.port
    auth_enabled     = var.auth_token_enabled
    tls_enabled      = var.transit_encryption_enabled
  }
}

# -----------------------------------------------------------------------------
# Redis Connection String
# -----------------------------------------------------------------------------
output "redis_cli_connection" {
  description = "Redis CLI connection command"
  value = var.transit_encryption_enabled ? (
    var.auth_token_enabled ?
    "redis-cli -h ${aws_elasticache_replication_group.this.primary_endpoint_address} -p ${var.port} --tls -a YOUR_AUTH_TOKEN" :
    "redis-cli -h ${aws_elasticache_replication_group.this.primary_endpoint_address} -p ${var.port} --tls"
    ) : (
    var.auth_token_enabled ?
    "redis-cli -h ${aws_elasticache_replication_group.this.primary_endpoint_address} -p ${var.port} -a YOUR_AUTH_TOKEN" :
    "redis-cli -h ${aws_elasticache_replication_group.this.primary_endpoint_address} -p ${var.port}"
  )
  sensitive = false
}

# -----------------------------------------------------------------------------
# CloudWatch Alarms
# -----------------------------------------------------------------------------
output "cloudwatch_alarm_cpu_arn" {
  description = "ARN of CPU alarm"
  value       = try(aws_cloudwatch_metric_alarm.cpu[0].arn, null)
}

output "cloudwatch_alarm_memory_arn" {
  description = "ARN of memory alarm"
  value       = try(aws_cloudwatch_metric_alarm.memory[0].arn, null)
}
