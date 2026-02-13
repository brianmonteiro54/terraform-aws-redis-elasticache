# =============================================================================
# CloudWatch Alarms for ElastiCache
# =============================================================================

# CPU Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "cpu" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${local.replication_group_id}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_cpu_threshold_evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = var.alarm_cpu_threshold_period
  statistic           = "Average"
  threshold           = var.alarm_cpu_threshold
  alarm_description   = "CPU utilization exceeds ${var.alarm_cpu_threshold}%"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ReplicationGroupId = aws_elasticache_replication_group.this.id
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  tags = local.common_tags
}

# Memory Utilization Alarm
resource "aws_cloudwatch_metric_alarm" "memory" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${local.replication_group_id}-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.alarm_memory_threshold_evaluation_periods
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = var.alarm_memory_threshold_period
  statistic           = "Average"
  threshold           = var.alarm_memory_threshold
  alarm_description   = "Memory usage exceeds ${var.alarm_memory_threshold}%"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ReplicationGroupId = aws_elasticache_replication_group.this.id
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  tags = local.common_tags
}

# Evictions Alarm
resource "aws_cloudwatch_metric_alarm" "evictions" {
  count = var.enable_cloudwatch_alarms && var.enable_evictions_alarm ? 1 : 0

  alarm_name          = "${local.replication_group_id}-high-evictions"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Evictions"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Sum"
  threshold           = var.alarm_evictions_threshold
  alarm_description   = "Cache evictions exceed threshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ReplicationGroupId = aws_elasticache_replication_group.this.id
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  tags = local.common_tags
}

# Replication Lag Alarm
resource "aws_cloudwatch_metric_alarm" "replication_lag" {
  count = var.enable_cloudwatch_alarms && var.num_cache_clusters > 1 ? 1 : 0

  alarm_name          = "${local.replication_group_id}-replication-lag"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ReplicationLag"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = var.alarm_replication_lag_threshold
  alarm_description   = "Replication lag exceeds threshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ReplicationGroupId = aws_elasticache_replication_group.this.id
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  tags = local.common_tags
}
