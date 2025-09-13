# Fundamentos de Terraform con AWS

Este directorio contiene los elementos básicos de Terraform para AWS.

## Archivos incluidos:

- `provider.tf`: Configuración del proveedor AWS
- `variables.tf`: Variables básicas para el proyecto
- `outputs.tf`: Outputs básicos para demostrar conceptos

## Ejercicio 1: Inicialización

1. Navega a este directorio:
   ```bash
   cd 01-fundamentos
   ```

2. Inicializa Terraform:
   ```bash
   terraform init
   ```

3. Valida la configuración:
   ```bash
   terraform validate
   ```

4. Revisa el plan (sin crear recursos):
   ```bash
   terraform plan
   ```

## Conceptos aprendidos:

- Configuración del proveedor AWS
- Declaración de variables
- Uso de outputs
- Comandos básicos de Terraform