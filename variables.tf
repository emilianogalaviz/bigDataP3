variable "aws_region" {
  description = "Región de AWS para el despliegue"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre base para los recursos"
  type        = string
  default     = "banking-fraud-processor"
}

variable "bucket_name" {
  description = "Nombre único para el bucket de S3"
  type        = string
  # Nota: S3 requiere nombres globales únicos. Cámbialo si es necesario.
  default = "uag-bigdata-project-banking-output"
}
