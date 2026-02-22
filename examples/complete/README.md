# Example: Complete ElastiCache Redis Cluster

This example provisions a production-ready Redis 7 replication group with high availability, encryption, and monitoring.

## What is created

- ElastiCache Redis 7.1 replication group (`cache.t3.micro`)
- 2 nodes — 1 primary + 1 replica across different AZs
- Multi-AZ with automatic failover
- Customer-managed KMS key for at-rest encryption (auto-created)
- In-transit encryption (TLS) enabled
- Redis AUTH token authentication
- Security group allowing Redis (6379) only from within the VPC
- Custom parameter group (`maxmemory-policy = allkeys-lru`)
- Automated daily snapshots with 7-day retention
- CloudWatch alarms: CPU > 75%, memory > 90%, evictions > 1000, replication lag > 30s

## Usage

```bash
terraform init

terraform plan \
  -var="vpc_id=vpc-xxxxxxxxxxxxxxxxx" \
  -var='subnet_ids=["subnet-aaa","subnet-bbb"]' \
  -var="auth_token=your-strong-password-here"

terraform apply \
  -var="vpc_id=vpc-xxxxxxxxxxxxxxxxx" \
  -var='subnet_ids=["subnet-aaa","subnet-bbb"]' \
  -var="auth_token=your-strong-password-here"
```

## Connecting

```bash
# CLI connection (from within the VPC)
redis-cli -h $(terraform output -raw primary_endpoint_address) \
          -p 6379 \
          --tls \
          -a your-strong-password-here

# Test connection
redis-cli -h $(terraform output -raw primary_endpoint_address) \
          -p 6379 --tls -a your-auth-token PING
```

## Inputs

| Name | Description | Required |
|------|-------------|----------|
| vpc_id | VPC ID for the security group | Yes |
| subnet_ids | List of private subnet IDs (min 2, different AZs) | Yes |
| auth_token | Redis AUTH password (16–128 chars) | Yes |
| aws_region | AWS region | No (default: `us-east-1`) |

## Outputs

| Name | Description |
|------|-------------|
| primary_endpoint_address | Write endpoint for your application |
| reader_endpoint_address | Read endpoint for read replicas |
| redis_cli_connection | Ready-to-use redis-cli command |
| kms_key_arn | KMS key ARN for at-rest encryption |
| security_group_id | Security group ID |

> **Tip:** Store `auth_token` in AWS SSM Parameter Store as a `SecureString` and
> reference it at apply time to avoid it appearing in shell history.

> **Production checklist:** Set `alarm_actions` with an SNS topic ARN for alerts.
> Use `cache.r7g.large` or larger for production workloads.
> Consider `cluster_mode_enabled = true` for horizontal scaling.
