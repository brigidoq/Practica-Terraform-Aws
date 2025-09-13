variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "wordpress-stack"
}

variable "environment" {
  description = "Ambiente"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "db_username" {
  description = "Usuario de la base de datos"
  type        = string
  default     = "wordpress"
}

variable "db_password" {
  description = "Contraseña de la base de datos"
  type        = string
  sensitive   = true
}

variable "instance_type" {
  description = "Tipo de instancia para WordPress"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Tamaño mínimo del Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Tamaño máximo del Auto Scaling Group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Capacidad deseada del Auto Scaling Group"
  type        = number
  default     = 2
}