# 🔴 Terraform AWS Redis ElastiCache

[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.9.0-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-~%3E%206.31-FF9900?logo=amazonaws)](https://registry.terraform.io/providers/hashicorp/aws/latest)

> **FIAP — Pós Tech · Tech Challenge — Fase 03 · ToggleMaster**
>
> Módulo Terraform para provisionamento de **Amazon ElastiCache for Redis** com replicação, criptografia e monitoramento.

---

## 📋 Descrição

Módulo completo para clusters Redis com:

- **Replication Groups** com réplicas configuráveis
- **Cluster Mode** habilitado/desabilitado
- **Encryption at Rest** via KMS (gerenciada AWS ou CMK)
- **Transit Encryption (TLS)** para dados em trânsito
- **AUTH Token** para autenticação (opcional)
- **Parameter Groups** customizáveis
- **Subnet Groups** para deploy em subnets privadas
- **Security Groups** com regras configuráveis
- **CloudWatch Alarms** para monitoramento

---

## 📦 Recursos Criados

| Recurso | Descrição |
|---------|-----------|
| `aws_elasticache_replication_group` | Grupo de replicação Redis |
| `aws_elasticache_subnet_group` | Subnet group |
| `aws_elasticache_parameter_group` | Parameter group customizado |
| `aws_security_group` | Security group com regras de acesso |
| `aws_kms_key` | Chave KMS para encryption at rest (opcional) |
| `aws_cloudwatch_metric_alarm` | Alarmes de monitoramento |

---

## 🚀 Uso

```hcl
module "redis" {
  source = "github.com/brianmonteiro54/terraform-aws-redis-elasticache//modules/redis?ref=<commit-sha>"

  replication_group_id = "togglemaster-redis"
  environment          = "production"
  description          = "Redis for ToggleMaster"

  engine_version = "7.1"
  node_type      = "cache.t4g.micro"

  subnet_ids            = module.vpc.private_subnet_ids
  create_security_group = true
  vpc_id                = module.vpc.vpc_id

  security_group_ingress_rules = [
    {
      from_port                = 6379
      to_port                  = 6379
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.eks_workers.id
      description              = "Allow Redis from EKS workers"
    }
  ]

  cluster_mode_enabled       = false
  replicas_per_node_group    = 2
  enable_encryption          = true
  transit_encryption_enabled = true
  create_kms_key             = false
}
```

---

## 📁 Estrutura

```
terraform-aws-redis-elasticache/
├── modules/
│   └── redis/
│       ├── main.tf
│       ├── subnet_group.tf
│       ├── parameter_group.tf
│       ├── security_groups.tf
│       ├── kms.tf
│       ├── alarms.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── locals.tf
│       ├── data.tf
│       └── provider.tf
├── .github/workflows/
│   └── terraform-ci.yml
└── LICENSE
```
## 📄 Licença

[MIT License](LICENSE)
