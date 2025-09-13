# Variables de configuración básica
variable "aws_region" {
  description = "Región de AWS donde desplegar recursos"
  type        = string
  default     = "us-east-1"
  
  validation {
    condition = can(regex("^[a-z0-9-]+$", var.aws_region))
    error_message = "La región debe tener un formato válido de AWS."
  }
}

# Variables para la aplicación
variable "app_name" {
  description = "Nombre de la aplicación"
  type        = string
  default     = "mi-app"
  
  validation {
    condition = length(var.app_name) > 2 && length(var.app_name) <= 20
    error_message = "El nombre de la aplicación debe tener entre 3 y 20 caracteres."
  }
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "dev"
  
  validation {
    condition = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El ambiente debe ser dev, staging o prod."
  }
}

# Variables para EC2
variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Número de instancias a crear"
  type        = number
  default     = 1
  
  validation {
    condition = var.instance_count >= 1 && var.instance_count <= 5
    error_message = "El número de instancias debe estar entre 1 y 5."
  }
}

# Variable tipo lista
variable "allowed_cidr_blocks" {
  description = "Lista de bloques CIDR permitidos para SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Variable tipo mapa
variable "common_tags" {
  description = "Tags comunes para todos los recursos"
  type        = map(string)
  default = {
    Project   = "Terraform-Practice"
    ManagedBy = "Terraform"
  }
}

# Variable tipo objeto
variable "s3_config" {
  description = "Configuración para el bucket S3"
  type = object({
    create_bucket = bool
    bucket_name   = string
    versioning    = bool
  })
  default = {
    create_bucket = false
    bucket_name   = ""
    versioning    = true
  }
}