# Outputs básicos para demostrar conceptos
output "aws_region" {
  description = "Región de AWS utilizada"
  value       = var.aws_region
}

output "project_name" {
  description = "Nombre del proyecto"
  value       = var.project_name
}

output "common_tags" {
  description = "Tags comunes aplicados a los recursos"
  value       = var.tags
}