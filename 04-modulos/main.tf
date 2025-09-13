# Tags comunes para todos los recursos
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    CreatedBy   = "Terraform-Modules"
  }
}

# Módulo VPC
module "vpc" {
  source = "./modules/vpc"

  project_name          = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
  availability_zones   = ["${var.aws_region}a", "${var.aws_region}b"]
  enable_nat_gateway   = false  # Para ejercicios básicos
  common_tags          = local.common_tags
}

# Módulo EC2
module "ec2" {
  source = "./modules/ec2"

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnet_ids
  instance_type   = var.instance_type
  instance_count  = var.instance_count
  
  ingress_rules = [
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
  
  create_load_balancer = var.instance_count > 1
  common_tags          = local.common_tags
  
  depends_on = [module.vpc]
}

# Módulo S3
module "s3" {
  source = "./modules/s3"

  bucket_name           = "${var.project_name}-${var.environment}-${random_string.bucket_suffix.result}"
  project_name          = var.project_name
  environment           = var.environment
  versioning_enabled    = true
  block_public_access   = true
  lifecycle_enabled     = true
  create_example_object = true
  common_tags           = local.common_tags
}

# Sufijo aleatorio para nombres únicos
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}