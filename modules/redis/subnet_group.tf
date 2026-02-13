# =============================================================================
# ElastiCache Subnet Group
# =============================================================================

resource "aws_elasticache_subnet_group" "this" {
  count = var.create_subnet_group ? 1 : 0

  name        = "${local.replication_group_id}-subnet-group"
  description = "Subnet group for ElastiCache Redis ${local.replication_group_id}"
  subnet_ids  = var.subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.replication_group_id}-subnet-group"
    }
  )
}
