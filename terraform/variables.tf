variable "project_id" {
  description = "ID del proyecto GCP"
  type        = string
  default     = "paralelos-cicd"
}

variable "region" {
  description = "Region GCP"
  type        = string
  default     = "us-central1"
}

variable "app_name" {
  description = "Nombre de la aplicacion"
  type        = string
  default     = "paralelos-api"
}

variable "cloud_run_image" {
  description = "Imagen Docker para Cloud Run"
  type        = string
  default     = "us-central1-docker.pkg.dev/paralelos-cicd/docker-repo/paralelos-api:latest"
}

variable "db_password" {
  description = "Password de la base de datos"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "Secreto JWT"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "calzado_db"
}

variable "db_user" {
  description = "Usuario de la base de datos"
  type        = string
  default     = "appuser"
}
