# Obtener la AMI más reciente de Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# VPC por defecto
data "aws_vpc" "default" {
  default = true
}

# Subred por defecto
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group básico
resource "aws_security_group" "web_sg" {
  name        = "terraform-practica-web-sg"
  description = "Security group para servidor web básico"
  vpc_id      = data.aws_vpc.default.id

  # Permite HTTP desde cualquier lugar
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permite SSH desde cualquier lugar (solo para práctica)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permite todo el tráfico saliente
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "terraform-practica-sg"
    Project   = "Terraform-AWS-Practice"
    ManagedBy = "Terraform"
  }
}

# Instancia EC2 básica
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = tolist(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>¡Hola desde Terraform!</h1>" > /var/www/html/index.html
    echo "<p>Instancia creada con Terraform en AWS</p>" >> /var/www/html/index.html
  EOF

  tags = {
    Name      = "terraform-practica-web"
    Project   = "Terraform-AWS-Practice"
    ManagedBy = "Terraform"
  }
}

# Bucket S3 (solo si se proporciona nombre)
resource "aws_s3_bucket" "ejemplo" {
  count  = var.bucket_name != "" ? 1 : 0
  bucket = var.bucket_name

  tags = {
    Name      = var.bucket_name
    Project   = "Terraform-AWS-Practice"
    ManagedBy = "Terraform"
  }
}

# Configuración de versionado para el bucket
resource "aws_s3_bucket_versioning" "ejemplo_versioning" {
  count  = var.bucket_name != "" ? 1 : 0
  bucket = aws_s3_bucket.ejemplo[0].id
  versioning_configuration {
    status = "Enabled"
  }
}