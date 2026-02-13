data "aws_iam_policy_document" "elasticache_kms" {
  #checkov:skip=CKV_AWS_356: KMS key policies typically require Resource="*" (policy evaluation scope is the key itself)
  #checkov:skip=CKV_AWS_111: Key admin permissions intentionally granted to account root for break-glass/recovery
  #checkov:skip=CKV_AWS_109: Permissions management is intentionally restricted to account root in the key policy

  statement {
    sid = "EnableIAMUserPermissions"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid = "AllowElastiCacheUseOfTheKey"
    principals {
      type        = "Service"
      identifiers = ["elasticache.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["elasticache.${data.aws_region.current.region}.amazonaws.com"]
    }
  }
}

resource "aws_kms_key" "elasticache" {
  count = (var.kms_key_arn == null && local.enable_encryption && var.create_kms_key) ? 1 : 0

  description             = "KMS key for ElastiCache Redis ${local.replication_group_id} encryption"
  deletion_window_in_days = var.kms_deletion_window_in_days
  enable_key_rotation     = true
  multi_region            = var.enable_multi_region

  policy = data.aws_iam_policy_document.elasticache_kms.json

  tags = merge(local.common_tags, {
    Name = "${local.replication_group_id}-elasticache-kms"
  })
}

resource "aws_kms_alias" "elasticache" {
  count = (var.kms_key_arn == null && local.enable_encryption && var.create_kms_key) ? 1 : 0

  name          = "alias/${local.replication_group_id}-elasticache"
  target_key_id = aws_kms_key.elasticache[0].key_id
}
