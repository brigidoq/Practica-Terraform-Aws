# 🚀 Práctica de Terraform con AWS

Repositorio completo de ejercicios en vivo y práctica de Terraform con Amazon Web Services (AWS). Aprende infraestructura como código desde lo básico hasta casos de uso avanzados.

## 📚 Contenido del Repositorio

### [01-fundamentos](./01-fundamentos/) - Conceptos Básicos
- Configuración del proveedor AWS
- Variables, outputs y configuraciones básicas
- Comandos fundamentales de Terraform
- Inicialización y validación

### [02-recursos-basicos](./02-recursos-basicos/) - Recursos AWS Esenciales
- Instancias EC2 con user data
- Security Groups y reglas de firewall
- Buckets S3 con configuración básica
- Data sources para obtener información existente

### [03-variables-outputs](./03-variables-outputs/) - Variables y Outputs Avanzados
- Tipos de variables complejas (list, map, object)
- Validaciones personalizadas
- Local values para cálculos
- Outputs con for expressions
- Templates y funciones

### [04-modulos](./04-modulos/) - Módulos Reutilizables
- Creación de módulos personalizados
- Módulo VPC con networking completo
- Módulo EC2 con Auto Scaling y Load Balancer
- Módulo S3 con configuración avanzada
- Composición de infraestructura modular

### [05-ejercicios-practicos](./05-ejercicios-practicos/) - Casos de Uso Reales
- **WordPress Stack**: Aplicación completa con RDS, EFS, ALB
- **E-commerce App**: Auto Scaling, ElastiCache, Lambda
- **Multi-tier App**: Arquitectura de 3 capas con ECS

### [06-mejores-practicas](./06-mejores-practicas/) - Mejores Prácticas
- Estructura de proyectos
- Backend remoto con S3 y DynamoDB
- Gestión de secretos y seguridad
- CI/CD con GitHub Actions
- Testing y validaciones
- Optimización de costos
- Monitoreo y alertas

## 🎯 Objetivos de Aprendizaje

Al completar estos ejercicios, serás capaz de:

- ✅ Configurar y gestionar infraestructura AWS con Terraform
- ✅ Crear módulos reutilizables y mantenibles
- ✅ Implementar arquitecturas complejas de múltiples servicios
- ✅ Aplicar mejores prácticas de seguridad e infraestructura
- ✅ Automatizar despliegues con CI/CD
- ✅ Optimizar costos y rendimiento
- ✅ Implementar monitoreo y alertas

## 🚀 Inicio Rápido

### Prerequisitos

1. **AWS CLI** configurado con credenciales válidas:
   ```bash
   aws configure
   ```

2. **Terraform** instalado (versión >= 1.0):
   ```bash
   # macOS
   brew install terraform
   
   # Linux
   wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
   unzip terraform_1.5.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   ```

3. **Permisos de IAM** apropiados para crear recursos AWS

### Tu Primer Ejercicio

```bash
# Clona el repositorio
git clone https://github.com/brigidoq/Practica-Terraform-Aws.git
cd Practica-Terraform-Aws

# Comienza con fundamentos
cd 01-fundamentos
terraform init
terraform validate
terraform plan
```

## 📖 Guía de Estudio

### Nivel Principiante (1-2 semanas)
1. Completa **01-fundamentos**
2. Practica **02-recursos-basicos**
3. Lee la documentación de cada ejercicio

### Nivel Intermedio (2-3 semanas)  
1. Domina **03-variables-outputs**
2. Construye módulos en **04-modulos**
3. Implementa el WordPress stack

### Nivel Avanzado (3-4 semanas)
1. Completa todos los **05-ejercicios-practicos**
2. Implementa **06-mejores-practicas**
3. Crea tus propios módulos y casos de uso

## 🛠️ Servicios AWS Cubiertos

- **Compute**: EC2, Auto Scaling Groups, Launch Templates
- **Networking**: VPC, Subnets, Route Tables, Load Balancers
- **Storage**: S3, EFS, EBS
- **Database**: RDS, ElastiCache
- **Security**: Security Groups, IAM, Secrets Manager
- **Monitoring**: CloudWatch, SNS
- **Content Delivery**: CloudFront
- **Containers**: ECS (en ejercicios avanzados)
- **Serverless**: Lambda (en ejercicios avanzados)

## 💡 Conceptos de Terraform Cubiertos

- **Configuración**: Providers, Resources, Data Sources
- **Variables**: Tipos, validaciones, archivos .tfvars
- **Outputs**: Simples y complejos con for expressions
- **Functions**: Built-in functions de Terraform
- **Modules**: Creación, composición y reutilización
- **State**: Gestión local y remota
- **Lifecycle**: prevent_destroy, ignore_changes
- **Provisioners**: local-exec, remote-exec (casos específicos)
- **Workspaces**: Gestión de múltiples ambientes

## 🔒 Consideraciones de Seguridad

- 🔐 **Credenciales**: Nunca hardcodees credenciales en el código
- 🏷️ **Tags**: Usa tags consistentes para governanza
- 🔑 **IAM**: Implementa principio de menor privilegio
- 🔒 **Encriptación**: Habilita encriptación en reposo y tránsito
- 🚫 **Acceso público**: Evita recursos públicos innecesarios
- 📝 **Auditoría**: Mantén logs de cambios y accesos

## 💰 Gestión de Costos

⚠️ **Importante**: Estos ejercicios pueden generar costos en AWS. Estimaciones aproximadas:

- **Ejercicios básicos** (01-03): ~$5-15/mes
- **Módulos** (04): ~$10-25/mes  
- **Ejercicios prácticos** (05): ~$20-100/mes
- **Siempre ejecuta** `terraform destroy` al finalizar

### Consejos para minimizar costos:
- Usa instancias t2.micro/t3.micro (free tier eligible)
- Detén recursos cuando no los uses
- Configura alertas de facturación
- Revisa regularmente AWS Cost Explorer

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Por favor:

1. Fork el repositorio
2. Crea una rama para tu feature
3. Sigue las mejores prácticas del repositorio
4. Agrega documentación apropiada
5. Envía un Pull Request

## 📞 Soporte

- 📖 Revisa la documentación de cada ejercicio
- 🐛 Reporta bugs mediante GitHub Issues
- 💬 Discusiones en GitHub Discussions
- 📧 Contacto directo mediante GitHub

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

## 🌟 Reconocimientos

- Comunidad de Terraform
- Documentación oficial de AWS
- Ejemplos de la comunidad DevOps

---

**¡Comienza tu viaje de aprendizaje con infraestructura como código!** 🚀

Recuerda: La práctica hace al maestro. Experimenta, rompe cosas, aprende y mejora. ¡Bienvenido al mundo de Terraform y AWS!
