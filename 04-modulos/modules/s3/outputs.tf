output "bucket_id" {
  description = "ID del bucket S3"
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.main.arn
}

output "bucket_domain_name" {
  description = "Nombre de dominio del bucket"
  value       = aws_s3_bucket.main.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Nombre de dominio regional del bucket"
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}

output "bucket_versioning_status" {
  description = "Estado del versionado del bucket"
  value       = aws_s3_bucket_versioning.main.versioning_configuration[0].status
}