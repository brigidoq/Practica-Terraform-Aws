# Módulos de Terraform

Este directorio demuestra cómo crear y usar módulos en Terraform para construir infraestructura modular y reutilizable.

## Estructura de Módulos

```
04-modulos/
├── modules/
│   ├── vpc/         # Módulo para VPC y networking
│   ├── ec2/         # Módulo para instancias EC2 y Load Balancer
│   └── s3/          # Módulo para buckets S3
├── main.tf          # Configuración principal que usa los módulos
├── variables.tf     # Variables del proyecto principal
├── outputs.tf       # Outputs del proyecto
└── README.md        # Esta documentación
```

## Módulos Incluidos

### 1. Módulo VPC (`modules/vpc/`)
- Crea VPC con subnets públicas y privadas
- Internet Gateway y Route Tables
- NAT Gateway (opcional)
- Configuración de múltiples AZs

### 2. Módulo EC2 (`modules/ec2/`)
- Launch Template con configuración personalizada
- Security Groups con reglas dinámicas
- Instancias EC2 distribuidas en múltiples AZs
- Application Load Balancer (opcional)
- Target Groups y Health Checks

### 3. Módulo S3 (`modules/s3/`)
- Bucket S3 con configuración completa
- Encriptación y versionado
- Políticas de acceso público
- Configuración de ciclo de vida
- Objetos de ejemplo

## Ejercicio 4: Usando Módulos

### Configuración Básica

1. Navega al directorio:
   ```bash
   cd 04-modulos
   ```

2. Crea archivo `terraform.tfvars`:
   ```hcl
   project_name   = "mi-proyecto-modular"
   environment    = "dev"
   aws_region     = "us-east-1"
   vpc_cidr       = "10.0.0.0/16"
   instance_type  = "t2.micro"
   instance_count = 2
   ```

3. Inicializa Terraform:
   ```bash
   terraform init
   ```

4. Valida la configuración:
   ```bash
   terraform validate
   ```

5. Revisa el plan:
   ```bash
   terraform plan
   ```

6. Aplica la configuración:
   ```bash
   terraform apply
   ```

### Configuración Avanzada

Para un ambiente más complejo:

```hcl
# terraform.tfvars
project_name   = "app-produccion"
environment    = "prod"
aws_region     = "us-west-2"
vpc_cidr       = "10.1.0.0/16"
instance_type  = "t3.medium"
instance_count = 3
```

### Comandos Útiles

1. **Ver outputs específicos**:
   ```bash
   terraform output web_urls
   terraform output architecture_summary
   ```

2. **Actualizar solo un módulo**:
   ```bash
   terraform apply -target=module.ec2
   ```

3. **Ver dependencias entre módulos**:
   ```bash
   terraform graph | dot -Tpng > dependencies.png
   ```

4. **Limpiar recursos**:
   ```bash
   terraform destroy
   ```

## Personalización de Módulos

### Modificar el módulo VPC

Para habilitar NAT Gateway:

```hcl
module "vpc" {
  source = "./modules/vpc"
  
  # ... otras configuraciones ...
  enable_nat_gateway = true
}
```

### Personalizar Security Groups

```hcl
module "ec2" {
  source = "./modules/ec2"
  
  # ... otras configuraciones ...
  ingress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]  # Solo desde la VPC
    }
  ]
}
```

### Configurar S3 con políticas custom

```hcl
module "s3" {
  source = "./modules/s3"
  
  # ... otras configuraciones ...
  bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${module.s3.bucket_arn}/public/*"
      }
    ]
  })
}
```

## Conceptos Aprendidos

- Creación de módulos reutilizables
- Paso de variables entre módulos
- Outputs y dependencias de módulos
- Organización de código modular
- Composición de infraestructura compleja
- Mejores prácticas de módulos
- Versionado de módulos (para futuros ejercicios)

## Siguientes Pasos

1. Crear módulos propios para otros servicios
2. Publicar módulos en Terraform Registry
3. Implementar versionado de módulos
4. Usar módulos remotos desde Git
5. Automatizar testing de módulos