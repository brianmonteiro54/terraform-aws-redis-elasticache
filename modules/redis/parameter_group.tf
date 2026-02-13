# =============================================================================
# ElastiCache Parameter Group
# =============================================================================

resource "aws_elasticache_parameter_group" "this" {
  count = var.create_parameter_group ? 1 : 0

  family      = var.parameter_group_family
  name        = "${local.replication_group_id}-params"
  description = "Parameter group for ElastiCache Redis ${local.replication_group_id}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.replication_group_id}-params"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
