# Local values para cálculos y combinaciones
locals {
  # Combinar tags
  instance_tags = merge(var.common_tags, {
    Name        = "${var.app_name}-${var.environment}"
    Environment = var.environment
  })
  
  # Generar nombres únicos
  security_group_name = "${var.app_name}-${var.environment}-sg"
  bucket_name = var.s3_config.create_bucket ? (
    var.s3_config.bucket_name != "" ? var.s3_config.bucket_name : 
    "${var.app_name}-${var.environment}-${random_string.bucket_suffix.result}"
  ) : ""
}

# Generar sufijo aleatorio para bucket
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Data source para obtener VPC por defecto
data "aws_vpc" "default" {
  default = true
}

# Data source para subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Data source para AMI de Amazon Linux
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Security Group con variables
resource "aws_security_group" "app_sg" {
  name        = local.security_group_name
  description = "Security group para ${var.app_name} en ${var.environment}"
  vpc_id      = data.aws_vpc.default.id

  # SSH desde CIDRs permitidos
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # HTTP desde cualquier lugar
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.instance_tags, {
    Name = local.security_group_name
  })
}

# Instancias EC2 usando count
resource "aws_instance" "app" {
  count                  = var.instance_count
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = element(data.aws_subnets.default.ids, count.index)
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = templatefile("${path.module}/user_data.sh", {
    app_name    = var.app_name
    environment = var.environment
    instance_number = count.index + 1
  })

  tags = merge(local.instance_tags, {
    Name = "${var.app_name}-${var.environment}-${count.index + 1}"
  })
}

# S3 Bucket condicional
resource "aws_s3_bucket" "app_bucket" {
  count  = var.s3_config.create_bucket ? 1 : 0
  bucket = local.bucket_name

  tags = merge(var.common_tags, {
    Name        = local.bucket_name
    Environment = var.environment
  })
}

resource "aws_s3_bucket_versioning" "app_bucket_versioning" {
  count  = var.s3_config.create_bucket && var.s3_config.versioning ? 1 : 0
  bucket = aws_s3_bucket.app_bucket[0].id
  
  versioning_configuration {
    status = "Enabled"
  }
}