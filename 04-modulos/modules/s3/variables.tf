variable "bucket_name" {
  description = "Nombre del bucket S3"
  type        = string
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "versioning_enabled" {
  description = "Habilitar versionado en el bucket"
  type        = bool
  default     = true
}

variable "block_public_access" {
  description = "Bloquear acceso público al bucket"
  type        = bool
  default     = true
}

variable "bucket_policy" {
  description = "Política JSON para el bucket"
  type        = string
  default     = ""
}

variable "lifecycle_enabled" {
  description = "Habilitar configuración de ciclo de vida"
  type        = bool
  default     = false
}

variable "transition_to_ia_days" {
  description = "Días para transición a IA"
  type        = number
  default     = 30
}

variable "transition_to_glacier_days" {
  description = "Días para transición a Glacier"
  type        = number
  default     = 90
}

variable "expiration_days" {
  description = "Días para expiración de objetos"
  type        = number
  default     = 365
}

variable "enable_notifications" {
  description = "Habilitar notificaciones de S3"
  type        = bool
  default     = false
}

variable "create_example_object" {
  description = "Crear objeto de ejemplo en el bucket"
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Tags comunes"
  type        = map(string)
  default     = {}
}