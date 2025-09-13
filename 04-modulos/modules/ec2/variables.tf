variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs de las subnets donde crear instancias"
  type        = list(string)
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Número de instancias a crear"
  type        = number
  default     = 1
}

variable "key_name" {
  description = "Nombre de la key pair para SSH"
  type        = string
  default     = ""
}

variable "public_key" {
  description = "Clave pública SSH"
  type        = string
  default     = ""
}

variable "ingress_rules" {
  description = "Reglas de ingreso para el security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "create_load_balancer" {
  description = "Crear Application Load Balancer"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Tags comunes"
  type        = map(string)
  default     = {}
}