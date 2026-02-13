# =============================================================================
# Local Variables
# =============================================================================

locals {

  # Common tags
  common_tags = merge(
    {
      Module      = "terraform-aws-elasticache"
      ManagedBy   = "Terraform"
      Environment = var.environment
      CostCenter  = var.cost_center
    },
    var.tags
  )
  # KMS key ARN to use (if encryption enabled)
  kms_key_id = local.enable_encryption ? (
    var.kms_key_id != null ? var.kms_key_id : (
      var.create_kms_key ? aws_kms_key.elasticache[0].arn : null
    )
  ) : null


  replication_group_id = lower(var.replication_group_id)

  # Encryption configuration (igual DynamoDB)
  enable_encryption = var.enable_encryption || var.kms_key_arn != null

  kms_key_arn = var.kms_key_arn != null ? var.kms_key_arn : (
    length(aws_kms_key.elasticache) > 0 ? aws_kms_key.elasticache[0].arn : null
  )

  # Security group IDs
  created_sg_ids     = var.create_security_group ? [aws_security_group.this[0].id] : []
  security_group_ids = distinct(concat(local.created_sg_ids, var.security_group_ids))

  subnet_group_name    = var.create_subnet_group ? aws_elasticache_subnet_group.this[0].name : var.subnet_group_name
  parameter_group_name = var.create_parameter_group ? aws_elasticache_parameter_group.this[0].name : var.parameter_group_name

}
