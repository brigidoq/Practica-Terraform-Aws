# Variables y Outputs Avanzados

Este directorio demuestra el uso avanzado de variables y outputs en Terraform.

## Conceptos incluidos:

- **Variables con validación**: Validaciones personalizadas para inputs
- **Variables de diferentes tipos**: string, number, list, map, object
- **Local values**: Cálculos y combinaciones de variables
- **Outputs complejos**: Usando for expressions y condicionales
- **Recursos condicionales**: Crear recursos basado en variables
- **Templates**: Usando templatefile para user data

## Ejercicio 3: Variables y Outputs

### Archivo de variables (terraform.tfvars)

Crea un archivo `terraform.tfvars` con tus valores:

```hcl
app_name     = "mi-aplicacion"
environment  = "dev"
aws_region   = "us-west-2"
instance_count = 2
instance_type = "t2.micro"

allowed_cidr_blocks = ["203.0.113.0/24", "198.51.100.0/24"]

common_tags = {
  Project     = "Mi-Proyecto"
  Owner       = "Tu-Nombre"
  Environment = "desarrollo"
  ManagedBy   = "Terraform"
}

s3_config = {
  create_bucket = true
  bucket_name   = "mi-bucket-personalizado"
  versioning    = true
}
```

### Pasos:

1. Navega al directorio:
   ```bash
   cd 03-variables-outputs
   ```

2. Crea el archivo `terraform.tfvars` con tus valores

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

6. Aplica con variables personalizadas:
   ```bash
   terraform apply
   ```

7. Revisa los outputs:
   ```bash
   terraform output
   ```

8. Prueba outputs específicos:
   ```bash
   terraform output web_urls
   terraform output instance_details
   ```

9. Limpia recursos:
   ```bash
   terraform destroy
   ```

### Experimentos adicionales:

1. **Cambiar número de instancias**:
   ```bash
   terraform apply -var="instance_count=3"
   ```

2. **Probar validaciones**:
   ```bash
   terraform apply -var="environment=invalid"  # Debería fallar
   ```

3. **Deshabilitar S3**:
   ```bash
   terraform apply -var='s3_config={create_bucket=false,bucket_name="",versioning=false}'
   ```

## Conceptos aprendidos:

- Validación de variables
- Tipos de datos complejos
- Local values y cálculos
- Outputs con for expressions
- Recursos condicionales
- Template functions
- Organización de variables