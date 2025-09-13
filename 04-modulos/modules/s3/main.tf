# Bucket S3 principal
resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  tags = merge(var.common_tags, {
    Name = var.bucket_name
  })
}

# Configuración de versionado
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Disabled"
  }
}

# Configuración de encriptación
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bloqueo de acceso público
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = var.block_public_access
  block_public_policy     = var.block_public_access
  ignore_public_acls      = var.block_public_access
  restrict_public_buckets = var.block_public_access
}

# Política del bucket (opcional)
resource "aws_s3_bucket_policy" "main" {
  count  = var.bucket_policy != "" ? 1 : 0
  bucket = aws_s3_bucket.main.id
  policy = var.bucket_policy
}

# Configuración de ciclo de vida
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  count  = var.lifecycle_enabled ? 1 : 0
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "transition-rule"
    status = "Enabled"

    transition {
      days          = var.transition_to_ia_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.transition_to_glacier_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.expiration_days
    }
  }
}

# Notificaciones de S3 (opcional)
resource "aws_s3_bucket_notification" "main" {
  count  = var.enable_notifications ? 1 : 0
  bucket = aws_s3_bucket.main.id

  # Ejemplo de configuración de notificaciones
  # Se puede personalizar según necesidades
}

# Objeto de ejemplo (opcional)
resource "aws_s3_object" "example" {
  count = var.create_example_object ? 1 : 0

  bucket = aws_s3_bucket.main.id
  key    = "example/terraform-created.txt"
  content = templatefile("${path.module}/example-content.txt", {
    bucket_name  = aws_s3_bucket.main.id
    project_name = var.project_name
    environment  = var.environment
    created_date = timestamp()
  })

  tags = var.common_tags
}