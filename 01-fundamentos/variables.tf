# Variables básicas para los ejercicios
variable "aws_region" {
  description = "Región de AWS donde desplegar los recursos"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto para etiquetar recursos"
  type        = string
  default     = "terraform-practica"
}

variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags comunes para todos los recursos"
  type        = map(string)
  default = {
    Project     = "Terraform-AWS-Practice"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}