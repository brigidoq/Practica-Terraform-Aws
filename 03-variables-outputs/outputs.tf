# Outputs básicos
output "app_name" {
  description = "Nombre de la aplicación"
  value       = var.app_name
}

output "environment" {
  description = "Ambiente de despliegue"
  value       = var.environment
}

output "aws_region" {
  description = "Región de AWS utilizada"
  value       = var.aws_region
}

# Outputs de instancias
output "instance_ids" {
  description = "IDs de las instancias EC2 creadas"
  value       = aws_instance.app[*].id
}

output "instance_public_ips" {
  description = "IPs públicas de las instancias"
  value       = aws_instance.app[*].public_ip
}

output "instance_private_ips" {
  description = "IPs privadas de las instancias"
  value       = aws_instance.app[*].private_ip
}

# Output complejo usando for
output "instance_details" {
  description = "Detalles completos de las instancias"
  value = {
    for i, instance in aws_instance.app : i => {
      id         = instance.id
      public_ip  = instance.public_ip
      private_ip = instance.private_ip
      az         = instance.availability_zone
      name       = instance.tags.Name
    }
  }
}

# Outputs condicionales
output "s3_bucket_name" {
  description = "Nombre del bucket S3 creado"
  value       = var.s3_config.create_bucket ? aws_s3_bucket.app_bucket[0].bucket : null
}

output "s3_bucket_arn" {
  description = "ARN del bucket S3"
  value       = var.s3_config.create_bucket ? aws_s3_bucket.app_bucket[0].arn : null
}

# Output de Security Group
output "security_group_id" {
  description = "ID del Security Group"
  value       = aws_security_group.app_sg.id
}

# Outputs calculados
output "web_urls" {
  description = "URLs para acceder a las aplicaciones web"
  value       = [for instance in aws_instance.app : "http://${instance.public_dns}"]
}

output "ssh_commands" {
  description = "Comandos SSH para conectarse a las instancias"
  value       = [for instance in aws_instance.app : "ssh -i your-key.pem ec2-user@${instance.public_ip}"]
}

# Output con datos locales
output "resource_names" {
  description = "Nombres de recursos generados"
  value = {
    security_group = local.security_group_name
    bucket_name    = local.bucket_name
    instance_tags  = local.instance_tags
  }
}