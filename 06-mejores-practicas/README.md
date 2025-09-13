# Mejores Prácticas de Terraform con AWS

Esta sección cubre las mejores prácticas para usar Terraform con AWS de manera efectiva y segura.

## 📁 Estructura de Proyecto

### Organización recomendada:
```
proyecto/
├── environments/
│   ├── dev/
│   ├── staging/
│   └── prod/
├── modules/
│   ├── vpc/
│   ├── ec2/
│   └── rds/
├── shared/
│   ├── backend.tf
│   └── variables.tf
└── scripts/
    ├── deploy.sh
    └── destroy.sh
```

## 🔧 Configuración de Backend

### Backend remoto con S3 y DynamoDB:

```hcl
terraform {
  backend "s3" {
    bucket         = "mi-empresa-terraform-state"
    key            = "environments/prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

### Crear resources para backend:

```hcl
# S3 bucket para state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "mi-empresa-terraform-state"
  
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DynamoDB para locking
resource "aws_dynamodb_table" "terraform_locks" {
  name           = "terraform-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
```

## 🏷️ Gestión de Tags

### Tags estandarizados:

```hcl
locals {
  common_tags = {
    Environment   = var.environment
    Project       = var.project_name
    Owner         = var.owner
    CostCenter    = var.cost_center
    ManagedBy     = "Terraform"
    Repository    = var.repository_url
    LastModified  = timestamp()
  }
}

# Aplicar a todos los recursos
resource "aws_instance" "example" {
  # ... configuración ...
  
  tags = merge(local.common_tags, {
    Name = "ejemplo-instancia"
    Role = "web-server"
  })
}
```

## 🔒 Seguridad

### 1. Secretos y variables sensibles:

```hcl
# Variables sensibles
variable "db_password" {
  description = "Contraseña de la base de datos"
  type        = string
  sensitive   = true
}

# Usar AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_password" {
  name = "${var.project_name}-db-password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}
```

### 2. IAM con menor privilegio:

```hcl
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

# Política específica en lugar de usar políticas AWS
data "aws_iam_policy_document" "ec2_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.app_bucket.arn}/*"]
  }
}
```

## 📝 Documentación

### README.md estándar:

```markdown
# Proyecto Terraform

## Descripción
[Descripción del proyecto]

## Arquitectura
[Diagrama o descripción de la arquitectura]

## Prerequisitos
- Terraform >= 1.0
- AWS CLI configurado
- Permisos IAM específicos

## Uso
\`\`\`bash
terraform init
terraform plan
terraform apply
\`\`\`

## Variables
| Variable | Descripción | Tipo | Default |
|----------|-------------|------|---------|
| region   | Región AWS  | string | us-east-1 |

## Outputs
| Output | Descripción |
|--------|-------------|
| vpc_id | ID de la VPC |
```

### Comentarios en código:

```hcl
# Crear VPC principal para la aplicación
# Incluye subnets públicas y privadas en múltiples AZs
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}
```

## 🔄 CI/CD

### GitHub Actions workflow:

```yaml
name: Terraform

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  terraform:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: 1.5.0
    
    - name: Terraform Init
      run: terraform init
      
    - name: Terraform Validate
      run: terraform validate
      
    - name: Terraform Plan
      run: terraform plan
      
    - name: Terraform Apply
      if: github.ref == 'refs/heads/main'
      run: terraform apply -auto-approve
```

## 🧪 Testing

### Usando Terratest (Go):

```go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestTerraformVPC(t *testing.T) {
    terraformOptions := &terraform.Options{
        TerraformDir: "../examples/vpc",
        Vars: map[string]interface{}{
            "vpc_cidr": "10.0.0.0/16",
        },
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    vpcId := terraform.Output(t, terraformOptions, "vpc_id")
    assert.NotEmpty(t, vpcId)
}
```

## 📊 Monitoreo y Alertas

### CloudWatch con Terraform:

```hcl
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.main.name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "EC2 CPU Utilization"
        }
      }
    ]
  })
}

# Alarmas automáticas
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]
}
```

## 🚦 Validaciones

### Validaciones de variables:

```hcl
variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t3.micro"
  
  validation {
    condition = can(regex("^t[2-3]\\.", var.instance_type))
    error_message = "El tipo de instancia debe ser de la familia t2 o t3."
  }
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  
  validation {
    condition = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El ambiente debe ser dev, staging o prod."
  }
}
```

## 💰 Optimización de Costos

### 1. Usar recursos apropiados:

```hcl
# Spot instances para desarrollo
resource "aws_launch_template" "dev" {
  count = var.environment == "dev" ? 1 : 0
  
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = "0.05"
    }
  }
}

# Scheduled scaling
resource "aws_autoscaling_schedule" "scale_down_evening" {
  count = var.environment == "dev" ? 1 : 0
  
  scheduled_action_name  = "scale_down_evening"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "0 18 * * MON-FRI"
  auto_scaling_group_name = aws_autoscaling_group.main.name
}
```

### 2. Políticas de lifecycle para S3:

```hcl
resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    id     = "cost_optimization"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}
```

## 🔧 Herramientas Útiles

### 1. Pre-commit hooks:

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.50.0
    hooks:
      - id: terraform_fmt
      - id: terraform_validate
      - id: terraform_docs
      - id: terraform_tflint
```

### 2. Makefile para automatización:

```makefile
.PHONY: init plan apply destroy validate fmt

init:
	terraform init

validate:
	terraform validate

fmt:
	terraform fmt -recursive

plan:
	terraform plan

apply:
	terraform apply

destroy:
	terraform destroy

docs:
	terraform-docs markdown . > README.md
```

## 📋 Checklist de Mejores Prácticas

- [ ] Backend remoto configurado
- [ ] Variables validadas
- [ ] Tags estandarizados aplicados
- [ ] Secretos gestionados apropiadamente
- [ ] IAM con menor privilegio
- [ ] Documentación actualizada
- [ ] Tests automatizados
- [ ] CI/CD configurado
- [ ] Monitoreo implementado
- [ ] Optimización de costos aplicada
- [ ] Pre-commit hooks configurados
- [ ] Versionado de módulos
- [ ] Plan de disaster recovery

## 🚨 Anti-patrones a Evitar

❌ **No hacer:**
- Hardcodear credenciales
- Usar count con recursos complejos
- Aplicar cambios sin plan
- Mezclar ambientes en el mismo state
- Usar políticas IAM muy amplias
- Ignorar outputs útiles
- No usar módulos para código repetitivo
- Saltarse validaciones

✅ **Hacer:**
- Usar for_each en lugar de count
- Implementar principio de menor privilegio
- Separar states por ambiente
- Crear módulos reutilizables
- Documentar todo cambio importante
- Implementar testing automatizado
- Usar tags consistentes