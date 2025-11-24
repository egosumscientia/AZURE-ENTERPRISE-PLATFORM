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

variable "application_gateway_id" {
  type        = string
  description = "ID del Application Gateway"
}

variable "vm_ids" {
  type        = list(string)
  description = "IDs de las VMs de aplicación"
}

variable "postgres_id" {
  type        = string
  description = "ID del servidor PostgreSQL"
}
