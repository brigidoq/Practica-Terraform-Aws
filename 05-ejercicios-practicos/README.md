# Ejercicios Prácticos

Esta sección contiene ejercicios prácticos que combinan múltiples servicios de AWS para crear aplicaciones completas.

## Ejercicios Disponibles

### 1. WordPress Stack (`wordpress-stack/`)
Despliega una aplicación WordPress completa con:
- VPC personalizada
- RDS MySQL
- EC2 con WordPress
- EFS para archivos compartidos
- Application Load Balancer
- CloudFront CDN

### 2. E-commerce App (`ecommerce-app/`)
Infraestructura para aplicación de e-commerce:
- Auto Scaling Groups
- ElastiCache Redis
- S3 para imágenes de productos
- Lambda para procesamiento
- SES para emails
- CloudWatch para monitoreo

### 3. Multi-tier App (`multi-tier-app/`)
Aplicación de tres capas:
- Web tier con Auto Scaling
- App tier con containers (ECS)
- Database tier con RDS Multi-AZ
- Bastion hosts para administración
- WAF para seguridad

## Instrucciones Generales

1. Cada ejercicio es independiente
2. Revisa el README de cada ejercicio para instrucciones específicas
3. Asegúrate de tener permisos adecuados en AWS
4. Algunos ejercicios pueden incurrir en costos
5. Siempre ejecuta `terraform destroy` al finalizar

## Prerequisitos

- AWS CLI configurado
- Terraform >= 1.0
- Permisos de IAM apropiados
- Conocimiento de los ejercicios anteriores

## Niveles de Dificultad

- 🟢 **Básico**: WordPress Stack
- 🟡 **Intermedio**: E-commerce App  
- 🔴 **Avanzado**: Multi-tier App

¡Comienza con el ejercicio que corresponda a tu nivel!