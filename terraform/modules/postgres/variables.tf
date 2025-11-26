variable "project_name" {
  type        = string
  description = "Nombre del proyecto"
}

variable "location" {
  type        = string
  description = "Región"
}

variable "environment" {
  type        = string
  description = "Entorno"
  default     = "dev"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group del módulo network"
}

variable "vnet_id" {
  type        = string
  description = "ID de la VNET desde module network"
}

variable "data_subnet_id" {
  type        = string
  description = "Subnet privada data"
}

variable "admin_username" {
  type        = string
  description = "Usuario administrador PostgreSQL"
  default     = "pgadmin"
}

variable "admin_password" {
  type        = string
  description = "Password del administrador PostgreSQL"
  sensitive   = true
}

variable "sku_name" {
  type        = string
  description = "SKU del servidor PostgreSQL Flexible Server"
  default     = "GP_Standard_D2s_v3"
}

variable "vnet_name" {
  type = string
}

