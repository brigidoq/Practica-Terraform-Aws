output "instance_ids" {
  description = "IDs de las instancias EC2"
  value       = aws_instance.main[*].id
}

output "instance_public_ips" {
  description = "IPs públicas de las instancias"
  value       = aws_instance.main[*].public_ip
}

output "instance_private_ips" {
  description = "IPs privadas de las instancias"
  value       = aws_instance.main[*].private_ip
}

output "security_group_id" {
  description = "ID del Security Group"
  value       = aws_security_group.main.id
}

output "launch_template_id" {
  description = "ID del Launch Template"
  value       = aws_launch_template.main.id
}

output "load_balancer_dns" {
  description = "DNS del Load Balancer"
  value       = var.create_load_balancer ? aws_lb.main[0].dns_name : null
}

output "load_balancer_arn" {
  description = "ARN del Load Balancer"
  value       = var.create_load_balancer ? aws_lb.main[0].arn : null
}

output "target_group_arn" {
  description = "ARN del Target Group"
  value       = var.create_load_balancer ? aws_lb_target_group.main[0].arn : null
}