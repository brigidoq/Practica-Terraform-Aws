# Configuración del proveedor AWS
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configuración del proveedor AWS
provider "aws" {
  region = var.aws_region
  
  # Para ejercicios, usar credenciales del entorno
  # AWS_ACCESS_KEY_ID y AWS_SECRET_ACCESS_KEY
}