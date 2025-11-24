variable "project_name" {
  type        = string
  description = "Nombre base del proyecto"
}

variable "location" {
  type        = string
  description = "Región de Azure"
}

variable "environment" {
  type        = string
  description = "Nombre del entorno (dev/stage/prod)"
  default     = "dev"
}
