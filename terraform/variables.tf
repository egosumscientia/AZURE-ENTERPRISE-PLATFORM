 variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "tenant_id" {
  description = "Tenant ID de Azure Active Directory"
  type        = string
}

variable "location" {
  description = "Región donde se desplegarán los recursos"
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "Nombre base del proyecto para etiquetado"
  type        = string
  default     = "enterprise-platform"
}

variable "environment" {
  description = "Entorno de despliegue (dev, qa, prod)"
  type        = string
}


