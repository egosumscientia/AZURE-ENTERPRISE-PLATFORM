variable "project_name" {
  type        = string
  description = "Nombre del proyecto"
}

variable "location" {
  type        = string
  description = "Región de Azure"
}

variable "environment" {
  type        = string
  description = "Entorno"
  default     = "dev"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group desde módulo network"
}

variable "public_subnet_id" {
  type        = string
  description = "Subnet pública donde corre Application Gateway"
}

variable "backend_ips" {
  type        = list(string)
  description = "IPs privadas de las VMs de aplicación"
}

variable "agw_capacity" {
  type        = number
  description = "Capacidad del Application Gateway"
  default     = 1
}
