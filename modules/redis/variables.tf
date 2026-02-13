# =============================================================================
# Variables - ElastiCache Redis Module
# =============================================================================

# -----------------------------------------------------------------------------
# Required Variables
# -----------------------------------------------------------------------------
variable "replication_group_id" {
  description = "Replication group identifier (max 40 chars, lowercase alphanumeric and hyphens)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{1,40}$", var.replication_group_id))
    error_message = "Must be lowercase alphanumeric and hyphens, max 40 chars."
  }
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string

  validation {
    condition     = can(regex("^(dev|development|staging|stage|prod|production|qa|test)$", var.environment))
    error_message = "Environment must be valid."
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs for the subnet group"
  type        = list(string)
}

# -----------------------------------------------------------------------------
# Optional - Basic Configuration
# -----------------------------------------------------------------------------
variable "description" {
  description = "Description of the replication group"
  type        = string
  default     = "Managed by Terraform"
}

variable "engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.1"
}

variable "port" {
  description = "Port number for Redis"
  type        = number
  default     = 6379
}

variable "node_type" {
  description = "Instance type (e.g., cache.t3.micro, cache.r6g.large)"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_clusters" {
  description = "Number of cache clusters (nodes) - use 2+ for HA"
  type        = number
  default     = 2
}

# -----------------------------------------------------------------------------
# High Availability Configuration
# -----------------------------------------------------------------------------
variable "automatic_failover_enabled" {
  description = "Enable automatic failover (requires 2+ nodes)"
  type        = bool
  default     = true
}

variable "multi_az_enabled" {
  description = "Enable Multi-AZ (requires automatic failover)"
  type        = bool
  default     = true
}

# -----------------------------------------------------------------------------
# Cluster Mode Configuration
# -----------------------------------------------------------------------------
variable "cluster_mode_enabled" {
  description = "Enable cluster mode (sharding)"
  type        = bool
  default     = false
}

variable "num_node_groups" {
  description = "Number of node groups (shards) in cluster mode"
  type        = number
  default     = 1
}

variable "replicas_per_node_group" {
  description = "Number of replicas per node group"
  type        = number
  default     = 1
}

# -----------------------------------------------------------------------------
# Security - Encryption
# -----------------------------------------------------------------------------
variable "enable_encryption" {
  description = "Enable at-rest encryption"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "ARN of existing KMS key"
  type        = string
  default     = null
}

variable "kms_deletion_window_in_days" {
  description = "KMS key deletion window"
  type        = number
  default     = 30

  validation {
    condition     = var.kms_deletion_window_in_days >= 7 && var.kms_deletion_window_in_days <= 30
    error_message = "Must be between 7 and 30 days."
  }
}

variable "enable_multi_region" {
  description = "Enable multi-region KMS key"
  type        = bool
  default     = false
}

variable "transit_encryption_enabled" {
  description = "Enable in-transit encryption (TLS)"
  type        = bool
  default     = true
}

variable "auth_token_enabled" {
  description = "Enable Redis AUTH token (password)"
  type        = bool
  default     = true
}

variable "auth_token" {
  description = "Redis AUTH token (min 16 chars, max 128 chars)"
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.auth_token == null || (length(var.auth_token) >= 16 && length(var.auth_token) <= 128)
    error_message = "Auth token must be between 16 and 128 characters."
  }
}

# -----------------------------------------------------------------------------
# Backup Configuration
# -----------------------------------------------------------------------------
variable "snapshot_retention_limit" {
  description = "Number of days to retain backups (0 to disable)"
  type        = number
  default     = 7

  validation {
    condition     = var.snapshot_retention_limit >= 0 && var.snapshot_retention_limit <= 35
    error_message = "Must be between 0 and 35 days."
  }
}

variable "snapshot_window" {
  description = "Daily time range for backups (UTC, format: HH:MM-HH:MM)"
  type        = string
  default     = "03:00-05:00"
}

variable "final_snapshot_identifier" {
  description = "Name of final snapshot before deletion"
  type        = string
  default     = null
}

variable "snapshot_name" {
  description = "Name of snapshot to restore from"
  type        = string
  default     = null
}

# -----------------------------------------------------------------------------
# Maintenance Configuration
# -----------------------------------------------------------------------------
variable "maintenance_window" {
  description = "Maintenance window (format: ddd:HH:MM-ddd:HH:MM)"
  type        = string
  default     = "sun:05:00-sun:07:00"
}

variable "notification_topic_arn" {
  description = "SNS topic ARN for notifications"
  type        = string
  default     = null
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Logging Configuration
# -----------------------------------------------------------------------------
variable "log_delivery_configuration" {
  description = "Log delivery configuration"
  type = list(object({
    destination      = string
    destination_type = string
    log_format       = string
    log_type         = string
  }))
  default = []
}

# -----------------------------------------------------------------------------
# Advanced Configuration
# -----------------------------------------------------------------------------
variable "user_group_ids" {
  description = "User group IDs for RBAC"
  type        = list(string)
  default     = null
}

variable "data_tiering_enabled" {
  description = "Enable data tiering (r6gd instances only)"
  type        = bool
  default     = false
}

# -----------------------------------------------------------------------------
# Network Configuration
# -----------------------------------------------------------------------------
variable "vpc_id" {
  description = "VPC ID (required if creating security group)"
  type        = string
  default     = null
}

variable "create_subnet_group" {
  description = "Create ElastiCache subnet group"
  type        = bool
  default     = true
}

variable "subnet_group_name" {
  description = "Name of existing subnet group"
  type        = string
  default     = null
}

variable "create_security_group" {
  description = "Create security group"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "Existing security group IDs"
  type        = list(string)
  default     = []
}

variable "security_group_ingress_rules" {
  description = "Security group ingress rules"
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
    description              = optional(string)
  }))
  default = []
}

variable "security_group_egress_rules" {
  description = "Security group egress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string))
    description = optional(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound"
    }
  ]
}

# -----------------------------------------------------------------------------
# Parameter Group Configuration
# -----------------------------------------------------------------------------
variable "create_parameter_group" {
  description = "Create parameter group"
  type        = bool
  default     = true
}

variable "parameter_group_name" {
  description = "Name of existing parameter group"
  type        = string
  default     = null
}

variable "parameter_group_family" {
  description = "Parameter group family (e.g., redis7)"
  type        = string
  default     = "redis7"
}

variable "parameters" {
  description = "Redis parameters"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# -----------------------------------------------------------------------------
# CloudWatch Alarms
# -----------------------------------------------------------------------------
variable "enable_cloudwatch_alarms" {
  description = "Enable CloudWatch alarms"
  type        = bool
  default     = false
}

variable "alarm_cpu_threshold" {
  description = "CPU utilization threshold (%)"
  type        = number
  default     = 75
}

variable "alarm_cpu_threshold_period" {
  description = "CPU alarm period (seconds)"
  type        = number
  default     = 300
}

variable "alarm_cpu_threshold_evaluation_periods" {
  description = "CPU alarm evaluation periods"
  type        = number
  default     = 2
}

variable "alarm_memory_threshold" {
  description = "Memory utilization threshold (%)"
  type        = number
  default     = 90
}

variable "alarm_memory_threshold_period" {
  description = "Memory alarm period (seconds)"
  type        = number
  default     = 300
}

variable "alarm_memory_threshold_evaluation_periods" {
  description = "Memory alarm evaluation periods"
  type        = number
  default     = 2
}

variable "enable_evictions_alarm" {
  description = "Enable evictions alarm"
  type        = bool
  default     = true
}

variable "alarm_evictions_threshold" {
  description = "Evictions threshold"
  type        = number
  default     = 1000
}

variable "alarm_replication_lag_threshold" {
  description = "Replication lag threshold (seconds)"
  type        = number
  default     = 30
}

variable "alarm_actions" {
  description = "SNS topic ARNs for alarm actions"
  type        = list(string)
  default     = []
}

variable "ok_actions" {
  description = "SNS topic ARNs for OK actions"
  type        = list(string)
  default     = []
}

# -----------------------------------------------------------------------------
# Tags
# -----------------------------------------------------------------------------
variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "cost_center" {
  description = "Cost center"
  type        = string
  default     = "engineering"
}
variable "create_kms_key" {
  type        = bool
  description = "Create a customer-managed KMS key (CMK) when encryption is enabled and kms_key_arn is null."
  default     = false
}

variable "kms_key_arn" {
  type        = string
  description = "Existing customer-managed KMS Key ARN to use for encryption at rest. If null and create_kms_key=true, a new key will be created."
  default     = null
}
