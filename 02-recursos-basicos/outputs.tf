output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "IP pública de la instancia EC2"
  value       = aws_instance.web_server.public_ip
}

output "instance_public_dns" {
  description = "DNS público de la instancia EC2"
  value       = aws_instance.web_server.public_dns
}

output "security_group_id" {
  description = "ID del Security Group"
  value       = aws_security_group.web_sg.id
}

output "s3_bucket_name" {
  description = "Nombre del bucket S3 (si fue creado)"
  value       = var.bucket_name != "" ? aws_s3_bucket.ejemplo[0].bucket : "No se creó bucket"
}

output "web_url" {
  description = "URL para acceder al servidor web"
  value       = "http://${aws_instance.web_server.public_dns}"
}