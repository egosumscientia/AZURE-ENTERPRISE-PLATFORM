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

variable "resource_group_name" {
  type        = string
  description = "Resource Group donde se desplegará el Bastion"
}

variable "bastion_subnet_id" {
  type        = string
  description = "ID de la subred pública donde se ubicará el Bastion Host"
}
