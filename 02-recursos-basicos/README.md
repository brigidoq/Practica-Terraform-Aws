# Recursos Básicos de AWS

Este directorio contiene ejemplos de recursos básicos de AWS con Terraform.

## Recursos incluidos:

- **EC2 Instance**: Servidor web básico con Apache
- **Security Group**: Grupo de seguridad para el servidor web
- **S3 Bucket**: Bucket de almacenamiento (opcional)

## Ejercicio 2: Crear recursos básicos

### Prerequisitos:
- Credenciales de AWS configuradas
- Permisos para crear EC2, Security Groups y S3

### Pasos:

1. Navega a este directorio:
   ```bash
   cd 02-recursos-basicos
   ```

2. Inicializa Terraform:
   ```bash
   terraform init
   ```

3. Revisa los recursos que se crearán:
   ```bash
   terraform plan
   ```

4. Crea los recursos:
   ```bash
   terraform apply
   ```

5. (Opcional) Para crear también un bucket S3:
   ```bash
   terraform apply -var="bucket_name=mi-bucket-terraform-practica-$(date +%s)"
   ```

6. Verifica que el servidor web funciona accediendo a la URL mostrada en el output

7. Limpia los recursos:
   ```bash
   terraform destroy
   ```

## Conceptos aprendidos:

- Data sources para obtener información existente
- Recursos EC2, Security Groups y S3
- User data para configurar instancias
- Uso de outputs para mostrar información importante
- Conditional resources (recursos condicionales)