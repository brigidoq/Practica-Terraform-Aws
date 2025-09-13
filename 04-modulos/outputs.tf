# Outputs del módulo VPC
output "vpc_id" {
  description = "ID de la VPC creada"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs de las subnets públicas"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs de las subnets privadas"
  value       = module.vpc.private_subnet_ids
}

# Outputs del módulo EC2
output "instance_ids" {
  description = "IDs de las instancias EC2"
  value       = module.ec2.instance_ids
}

output "instance_public_ips" {
  description = "IPs públicas de las instancias"
  value       = module.ec2.instance_public_ips
}

output "load_balancer_dns" {
  description = "DNS del Load Balancer (si está creado)"
  value       = module.ec2.load_balancer_dns
}

output "security_group_id" {
  description = "ID del Security Group"
  value       = module.ec2.security_group_id
}

# Outputs del módulo S3
output "s3_bucket_id" {
  description = "ID del bucket S3"
  value       = module.s3.bucket_id
}

output "s3_bucket_arn" {
  description = "ARN del bucket S3"
  value       = module.s3.bucket_arn
}

# Outputs combinados útiles
output "web_urls" {
  description = "URLs para acceder a las aplicaciones web"
  value = concat(
    [for ip in module.ec2.instance_public_ips : "http://${ip}"],
    module.ec2.load_balancer_dns != null ? ["http://${module.ec2.load_balancer_dns}"] : []
  )
}

output "architecture_summary" {
  description = "Resumen de la arquitectura creada"
  value = {
    vpc = {
      id                    = module.vpc.vpc_id
      cidr                  = module.vpc.vpc_cidr_block
      public_subnets_count  = length(module.vpc.public_subnet_ids)
      private_subnets_count = length(module.vpc.private_subnet_ids)
    }
    ec2 = {
      instance_count      = length(module.ec2.instance_ids)
      instance_type       = var.instance_type
      load_balancer_enabled = module.ec2.load_balancer_dns != null
    }
    s3 = {
      bucket_name = module.s3.bucket_id
      versioning  = module.s3.bucket_versioning_status
    }
  }
}