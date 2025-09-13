# WordPress Stack - Ejercicio Práctico

Este ejercicio demuestra cómo crear un stack completo de WordPress en AWS usando Terraform.

## 🏗️ Arquitectura

- **VPC**: Red privada virtual con subnets públicas y privadas
- **RDS**: Base de datos MySQL para WordPress
- **EFS**: Sistema de archivos compartido para wp-content
- **EC2**: Auto Scaling Group con instancias WordPress
- **ALB**: Application Load Balancer para distribución de tráfico
- **CloudFront**: CDN para optimización de contenido

## 📋 Prerequisitos

- AWS CLI configurado
- Terraform instalado
- Permisos para crear RDS, EC2, EFS, ALB, CloudFront

## 🚀 Instrucciones

### 1. Configuración inicial

```bash
cd 05-ejercicios-practicos/wordpress-stack
```

### 2. Configurar variables

Crea `terraform.tfvars`:
```hcl
aws_region     = "us-east-1"
project_name   = "mi-wordpress"
environment    = "production"
db_password    = "TuPasswordSegura123!"
instance_type  = "t3.small"
min_size       = 1
max_size       = 3
desired_capacity = 2
```

### 3. Desplegar infraestructura

```bash
terraform init
terraform plan
terraform apply
```

### 4. Configurar WordPress

1. Accede a la URL del Load Balancer (output `wordpress_url`)
2. Completa la instalación de WordPress
3. Configura tu sitio

### 5. Probar escalabilidad

Simula carga para ver el Auto Scaling en acción:
```bash
# Usar herramientas como ab o siege
ab -n 1000 -c 10 http://[ALB-DNS]/
```

### 6. Limpieza

```bash
terraform destroy
```

## 🔧 Personalización

### Cambiar tipo de instancia
```hcl
instance_type = "t3.medium"
```

### Ajustar Auto Scaling
```hcl
min_size = 2
max_size = 5
desired_capacity = 3
```

### Usar RDS más potente
```hcl
db_instance_class = "db.t3.small"
```

## 📊 Monitoreo

- CloudWatch Dashboards automáticos
- Alarmas de Auto Scaling
- Logs de aplicación en CloudWatch

## 💡 Conceptos Aprendidos

- Diseño de arquitectura de 3 capas
- Auto Scaling y Load Balancing
- Sistemas de archivos compartidos (EFS)
- CDN con CloudFront
- Seguridad con Security Groups
- Bases de datos gestionadas (RDS)

## ⚠️ Costos Estimados

**Importante**: Este ejercicio puede generar costos en AWS (~$20-50/mes)

- RDS MySQL: ~$15/mes
- EC2 instances: ~$10-30/mes  
- EFS: ~$0.30/GB/mes
- ALB: ~$16/mes
- CloudFront: Según uso

## 🔐 Seguridad

- Base de datos en subnets privadas
- Security Groups restrictivos
- EFS encriptado
- SSL/TLS en Load Balancer (opcional)

## 🚨 Troubleshooting

### WordPress no se conecta a la BD
- Verificar Security Groups
- Revisar credenciales en user_data
- Comprobar conectividad VPC

### Instancias no aparecen en el ALB
- Verificar Health Checks
- Revisar Security Groups
- Comprobar user_data script

### EFS no monta
- Verificar NFS Security Group
- Comprobar route tables
- Revisar permisos de EFS