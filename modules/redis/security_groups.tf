# =============================================================================
# Security Group for ElastiCache
# =============================================================================

resource "aws_security_group" "this" {
  #checkov:skip=CKV2_AWS_5: Attached to ElastiCache replication group via security_group_ids
  count = var.create_security_group ? 1 : 0

  name_prefix = "${local.replication_group_id}-"
  description = "Security group for ElastiCache Redis ${local.replication_group_id}"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.replication_group_id}-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Ingress Rules
resource "aws_security_group_rule" "ingress" {
  for_each = var.create_security_group ? { for idx, rule in var.security_group_ingress_rules : idx => rule } : {}

  type                     = "ingress"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  security_group_id        = aws_security_group.this[0].id
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
  description              = lookup(each.value, "description", "Managed by Terraform")
}

# Egress Rules
resource "aws_security_group_rule" "egress" {
  for_each = var.create_security_group ? { for idx, rule in var.security_group_egress_rules : idx => rule } : {}

  type              = "egress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = lookup(each.value, "cidr_blocks", null)
  security_group_id = aws_security_group.this[0].id
  description       = lookup(each.value, "description", "Managed by Terraform")
}
