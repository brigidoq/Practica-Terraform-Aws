variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "bucket_name" {
  description = "Nombre del bucket S3 (debe ser único globalmente)"
  type        = string
  default     = ""
}