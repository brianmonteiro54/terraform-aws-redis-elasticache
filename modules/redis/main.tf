resource "aws_elasticache_replication_group" "this" {
  replication_group_id    = local.replication_group_id
  description             = var.description
  num_node_groups         = var.cluster_mode_enabled ? var.num_node_groups : null
  replicas_per_node_group = var.cluster_mode_enabled ? var.replicas_per_node_group : null


  # Engine Configuration
  engine               = "redis"
  engine_version       = var.engine_version
  port                 = var.port
  parameter_group_name = local.parameter_group_name

  # Node Configuration
  node_type                  = var.node_type
  num_cache_clusters         = var.cluster_mode_enabled ? null : var.num_cache_clusters
  automatic_failover_enabled = var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled


  # Network Configuration
  subnet_group_name  = local.subnet_group_name
  security_group_ids = local.security_group_ids

  # Encryption Configuration
  at_rest_encryption_enabled = local.enable_encryption
  kms_key_id                 = local.kms_key_id
  transit_encryption_enabled = var.transit_encryption_enabled

  # Auth token (sem auth_token_enabled!)
  auth_token = var.auth_token_enabled ? var.auth_token : null

  # Backup Configuration
  snapshot_retention_limit  = var.snapshot_retention_limit
  snapshot_window           = var.snapshot_window
  final_snapshot_identifier = var.final_snapshot_identifier
  snapshot_name             = var.snapshot_name

  # Maintenance Configuration
  maintenance_window         = var.maintenance_window
  notification_topic_arn     = var.notification_topic_arn
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  apply_immediately          = var.apply_immediately

  # Logging Configuration
  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configuration
    content {
      destination      = log_delivery_configuration.value.destination
      destination_type = log_delivery_configuration.value.destination_type
      log_format       = log_delivery_configuration.value.log_format
      log_type         = log_delivery_configuration.value.log_type
    }
  }

  # User Group IDs (RBAC)
  user_group_ids = var.user_group_ids

  # Data Tiering (r6gd instances)
  data_tiering_enabled = var.data_tiering_enabled

  tags = merge(local.common_tags, { Name = local.replication_group_id })

  lifecycle {
    ignore_changes = [engine_version]
  }

  depends_on = [
    aws_elasticache_subnet_group.this,
    aws_elasticache_parameter_group.this
  ]
}
