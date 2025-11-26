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
  default     = "eastus2"
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

variable "ssh_public_key_path" {
  type = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group donde se desplegarán los recursos"
  type        = string
}



