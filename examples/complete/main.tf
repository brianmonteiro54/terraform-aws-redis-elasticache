# =============================================================================
# Example: Complete ElastiCache Redis Cluster
#
# This example provisions a production-ready Redis replication group with:
#   - 2 nodes for high availability (primary + replica)
#   - Multi-AZ with automatic failover
#   - At-rest encryption with a customer-managed KMS key (auto-created)
#   - In-transit encryption (TLS)
#   - Redis AUTH token for authentication
#   - Security group allowing Redis only from within the VPC
#   - Custom parameter group (Redis 7)
#   - Automated daily snapshots with 7-day retention
#   - CloudWatch alarms for CPU, memory, evictions, and replication lag
#
# Usage:
#   terraform init
#   terraform plan \
#     -var="vpc_id=vpc-xxxx" \
#     -var='subnet_ids=["subnet-aaa","subnet-bbb"]' \
#     -var="auth_token=your-strong-password-here"
#   terraform apply \
#     -var="vpc_id=vpc-xxxx" \
#     -var='subnet_ids=["subnet-aaa","subnet-bbb"]' \
#     -var="auth_token=your-strong-password-here"
#
# Tip: store auth_token in SSM Parameter Store:
#   aws ssm put-parameter --name /myapp/redis/auth_token \
#     --value "your-strong-password" --type SecureString
#   Then: -var="auth_token=$(aws ssm get-parameter --name /myapp/redis/auth_token \
#     --with-decryption --query Parameter.Value --output text)"
# =============================================================================

module "redis" {
  source = "../../modules/redis"

  # ---------------------------------------------------
  # Required
  # ---------------------------------------------------
  replication_group_id = "my-app-redis"
  environment          = "dev"
  subnet_ids           = var.subnet_ids

  # ---------------------------------------------------
  # Engine
  # ---------------------------------------------------
  engine_version = "7.1"
  node_type      = "cache.t3.micro"
  port           = 6379

  # ---------------------------------------------------
  # High Availability
  # 2 nodes = 1 primary + 1 replica across AZs
  # ---------------------------------------------------
  num_cache_clusters         = 2
  automatic_failover_enabled = true
  multi_az_enabled           = true
  cluster_mode_enabled       = false

  # ---------------------------------------------------
  # Encryption
  # ---------------------------------------------------
  enable_encryption          = true
  create_kms_key             = true # Creates a CMK automatically
  transit_encryption_enabled = true

  # ---------------------------------------------------
  # Authentication
  # auth_token is a shared password — store securely
  # ---------------------------------------------------
  auth_token_enabled = true
  auth_token         = var.auth_token

  # ---------------------------------------------------
  # Security Group — Redis (6379) from VPC only
  # ---------------------------------------------------
  create_security_group = true
  vpc_id                = var.vpc_id

  security_group_ingress_rules = [
    {
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
      description = "Redis from within VPC"
    }
  ]

  # ---------------------------------------------------
  # Parameter Group — Redis 7 with sensible defaults
  # ---------------------------------------------------
  create_parameter_group = true
  parameter_group_family = "redis7"

  parameters = [
    {
      name  = "maxmemory-policy"
      value = "allkeys-lru" # Evict least-recently-used keys when memory is full
    }
  ]

  # ---------------------------------------------------
  # Backup — 7-day retention, daily at 3 AM UTC
  # ---------------------------------------------------
  snapshot_retention_limit = 7
  snapshot_window          = "03:00-05:00"

  # ---------------------------------------------------
  # Maintenance
  # ---------------------------------------------------
  maintenance_window         = "sun:05:00-sun:07:00"
  auto_minor_version_upgrade = true
  apply_immediately          = false

  # ---------------------------------------------------
  # CloudWatch Alarms
  # Add alarm_actions = ["arn:aws:sns:..."] for notifications
  # ---------------------------------------------------
  enable_cloudwatch_alarms = true

  alarm_cpu_threshold                    = 75
  alarm_cpu_threshold_period             = 300
  alarm_cpu_threshold_evaluation_periods = 2

  alarm_memory_threshold                    = 90
  alarm_memory_threshold_period             = 300
  alarm_memory_threshold_evaluation_periods = 2

  enable_evictions_alarm          = true
  alarm_evictions_threshold       = 1000
  alarm_replication_lag_threshold = 30

  # ---------------------------------------------------
  # Tags
  # ---------------------------------------------------
  tags = {
    Project    = "my-app"
    Owner      = "platform-team"
    CostCenter = "engineering"
  }
}
