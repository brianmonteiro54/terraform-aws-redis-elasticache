# Redis Module

Módulo Terraform para criação de Redis na AWS.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.31 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.32.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.evictions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.replication_lag](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_elasticache_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_kms_alias.elasticache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.elasticache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.elasticache_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | SNS topic ARNs for alarm actions | `list(string)` | `[]` | no |
| <a name="input_alarm_cpu_threshold"></a> [alarm\_cpu\_threshold](#input\_alarm\_cpu\_threshold) | CPU utilization threshold (%) | `number` | `75` | no |
| <a name="input_alarm_cpu_threshold_evaluation_periods"></a> [alarm\_cpu\_threshold\_evaluation\_periods](#input\_alarm\_cpu\_threshold\_evaluation\_periods) | CPU alarm evaluation periods | `number` | `2` | no |
| <a name="input_alarm_cpu_threshold_period"></a> [alarm\_cpu\_threshold\_period](#input\_alarm\_cpu\_threshold\_period) | CPU alarm period (seconds) | `number` | `300` | no |
| <a name="input_alarm_evictions_threshold"></a> [alarm\_evictions\_threshold](#input\_alarm\_evictions\_threshold) | Evictions threshold | `number` | `1000` | no |
| <a name="input_alarm_memory_threshold"></a> [alarm\_memory\_threshold](#input\_alarm\_memory\_threshold) | Memory utilization threshold (%) | `number` | `90` | no |
| <a name="input_alarm_memory_threshold_evaluation_periods"></a> [alarm\_memory\_threshold\_evaluation\_periods](#input\_alarm\_memory\_threshold\_evaluation\_periods) | Memory alarm evaluation periods | `number` | `2` | no |
| <a name="input_alarm_memory_threshold_period"></a> [alarm\_memory\_threshold\_period](#input\_alarm\_memory\_threshold\_period) | Memory alarm period (seconds) | `number` | `300` | no |
| <a name="input_alarm_replication_lag_threshold"></a> [alarm\_replication\_lag\_threshold](#input\_alarm\_replication\_lag\_threshold) | Replication lag threshold (seconds) | `number` | `30` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Apply changes immediately | `bool` | `false` | no |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token) | Redis AUTH token (min 16 chars, max 128 chars) | `string` | `null` | no |
| <a name="input_auth_token_enabled"></a> [auth\_token\_enabled](#input\_auth\_token\_enabled) | Enable Redis AUTH token (password) | `bool` | `true` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Enable automatic minor version upgrades | `bool` | `true` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | Enable automatic failover (requires 2+ nodes) | `bool` | `true` | no |
| <a name="input_cluster_mode_enabled"></a> [cluster\_mode\_enabled](#input\_cluster\_mode\_enabled) | Enable cluster mode (sharding) | `bool` | `false` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost center | `string` | `"engineering"` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | Create a customer-managed KMS key (CMK) when encryption is enabled and kms\_key\_arn is null. | `bool` | `false` | no |
| <a name="input_create_parameter_group"></a> [create\_parameter\_group](#input\_create\_parameter\_group) | Create parameter group | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Create security group | `bool` | `false` | no |
| <a name="input_create_subnet_group"></a> [create\_subnet\_group](#input\_create\_subnet\_group) | Create ElastiCache subnet group | `bool` | `true` | no |
| <a name="input_data_tiering_enabled"></a> [data\_tiering\_enabled](#input\_data\_tiering\_enabled) | Enable data tiering (r6gd instances only) | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the replication group | `string` | `"Managed by Terraform"` | no |
| <a name="input_enable_cloudwatch_alarms"></a> [enable\_cloudwatch\_alarms](#input\_enable\_cloudwatch\_alarms) | Enable CloudWatch alarms | `bool` | `false` | no |
| <a name="input_enable_encryption"></a> [enable\_encryption](#input\_enable\_encryption) | Enable at-rest encryption | `bool` | `true` | no |
| <a name="input_enable_evictions_alarm"></a> [enable\_evictions\_alarm](#input\_enable\_evictions\_alarm) | Enable evictions alarm | `bool` | `true` | no |
| <a name="input_enable_multi_region"></a> [enable\_multi\_region](#input\_enable\_multi\_region) | Enable multi-region KMS key | `bool` | `false` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Redis engine version | `string` | `"7.1"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (dev/staging/prod) | `string` | n/a | yes |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | Name of final snapshot before deletion | `string` | `null` | no |
| <a name="input_kms_deletion_window_in_days"></a> [kms\_deletion\_window\_in\_days](#input\_kms\_deletion\_window\_in\_days) | KMS key deletion window | `number` | `30` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Existing customer-managed KMS Key ARN to use for encryption at rest. If null and create\_kms\_key=true, a new key will be created. | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | ARN of existing KMS key | `string` | `null` | no |
| <a name="input_log_delivery_configuration"></a> [log\_delivery\_configuration](#input\_log\_delivery\_configuration) | Log delivery configuration | <pre>list(object({<br/>    destination      = string<br/>    destination_type = string<br/>    log_format       = string<br/>    log_type         = string<br/>  }))</pre> | `[]` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window (format: ddd:HH:MM-ddd:HH:MM) | `string` | `"sun:05:00-sun:07:00"` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Enable Multi-AZ (requires automatic failover) | `bool` | `true` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance type (e.g., cache.t3.micro, cache.r6g.large) | `string` | `"cache.t3.micro"` | no |
| <a name="input_notification_topic_arn"></a> [notification\_topic\_arn](#input\_notification\_topic\_arn) | SNS topic ARN for notifications | `string` | `null` | no |
| <a name="input_num_cache_clusters"></a> [num\_cache\_clusters](#input\_num\_cache\_clusters) | Number of cache clusters (nodes) - use 2+ for HA | `number` | `2` | no |
| <a name="input_num_node_groups"></a> [num\_node\_groups](#input\_num\_node\_groups) | Number of node groups (shards) in cluster mode | `number` | `1` | no |
| <a name="input_ok_actions"></a> [ok\_actions](#input\_ok\_actions) | SNS topic ARNs for OK actions | `list(string)` | `[]` | no |
| <a name="input_parameter_group_family"></a> [parameter\_group\_family](#input\_parameter\_group\_family) | Parameter group family (e.g., redis7) | `string` | `"redis7"` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Name of existing parameter group | `string` | `null` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | Redis parameters | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_port"></a> [port](#input\_port) | Port number for Redis | `number` | `6379` | no |
| <a name="input_replicas_per_node_group"></a> [replicas\_per\_node\_group](#input\_replicas\_per\_node\_group) | Number of replicas per node group | `number` | `1` | no |
| <a name="input_replication_group_id"></a> [replication\_group\_id](#input\_replication\_group\_id) | Replication group identifier (max 40 chars, lowercase alphanumeric and hyphens) | `string` | n/a | yes |
| <a name="input_security_group_egress_rules"></a> [security\_group\_egress\_rules](#input\_security\_group\_egress\_rules) | Security group egress rules | <pre>list(object({<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>    cidr_blocks = optional(list(string))<br/>    description = optional(string)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "Allow all outbound",<br/>    "from_port": 0,<br/>    "protocol": "-1",<br/>    "to_port": 0<br/>  }<br/>]</pre> | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Existing security group IDs | `list(string)` | `[]` | no |
| <a name="input_security_group_ingress_rules"></a> [security\_group\_ingress\_rules](#input\_security\_group\_ingress\_rules) | Security group ingress rules | <pre>list(object({<br/>    from_port                = number<br/>    to_port                  = number<br/>    protocol                 = string<br/>    cidr_blocks              = optional(list(string))<br/>    source_security_group_id = optional(string)<br/>    description              = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_snapshot_name"></a> [snapshot\_name](#input\_snapshot\_name) | Name of snapshot to restore from | `string` | `null` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | Number of days to retain backups (0 to disable) | `number` | `7` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | Daily time range for backups (UTC, format: HH:MM-HH:MM) | `string` | `"03:00-05:00"` | no |
| <a name="input_subnet_group_name"></a> [subnet\_group\_name](#input\_subnet\_group\_name) | Name of existing subnet group | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the subnet group | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags | `map(string)` | `{}` | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | Enable in-transit encryption (TLS) | `bool` | `true` | no |
| <a name="input_user_group_ids"></a> [user\_group\_ids](#input\_user\_group\_ids) | User group IDs for RBAC | `list(string)` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID (required if creating security group) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_alarm_cpu_arn"></a> [cloudwatch\_alarm\_cpu\_arn](#output\_cloudwatch\_alarm\_cpu\_arn) | ARN of CPU alarm |
| <a name="output_cloudwatch_alarm_memory_arn"></a> [cloudwatch\_alarm\_memory\_arn](#output\_cloudwatch\_alarm\_memory\_arn) | ARN of memory alarm |
| <a name="output_connection_info"></a> [connection\_info](#output\_connection\_info) | Connection information for applications |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | KMS alias created for ElastiCache CMK (if created). |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS key ARN in use (null if AWS-managed encryption). |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | KMS key ID |
| <a name="output_parameter_group_name"></a> [parameter\_group\_name](#output\_parameter\_group\_name) | Name of the parameter group |
| <a name="output_redis_cli_connection"></a> [redis\_cli\_connection](#output\_redis\_cli\_connection) | Redis CLI connection command |
| <a name="output_replication_group_arn"></a> [replication\_group\_arn](#output\_replication\_group\_arn) | ARN of the replication group |
| <a name="output_replication_group_configuration_endpoint_address"></a> [replication\_group\_configuration\_endpoint\_address](#output\_replication\_group\_configuration\_endpoint\_address) | Configuration endpoint (cluster mode) |
| <a name="output_replication_group_id"></a> [replication\_group\_id](#output\_replication\_group\_id) | ID of the ElastiCache replication group |
| <a name="output_replication_group_member_clusters"></a> [replication\_group\_member\_clusters](#output\_replication\_group\_member\_clusters) | Member cluster IDs |
| <a name="output_replication_group_primary_endpoint_address"></a> [replication\_group\_primary\_endpoint\_address](#output\_replication\_group\_primary\_endpoint\_address) | Primary endpoint address |
| <a name="output_replication_group_reader_endpoint_address"></a> [replication\_group\_reader\_endpoint\_address](#output\_replication\_group\_reader\_endpoint\_address) | Reader endpoint address |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | ARN of the security group |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the security group |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the subnet group |
<!-- END_TF_DOCS -->