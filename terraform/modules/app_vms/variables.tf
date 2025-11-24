variable "project_name" {
  type        = string
  description = "Nombre del proyecto"
}

variable "location" {
  type        = string
  description = "Región donde se despliegan las VMs"
}

variable "environment" {
  type        = string
  description = "Entorno del proyecto"
  default     = "dev"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group desde module network"
}

variable "app_subnet_id" {
  type        = string
  description = "Subnet privada app"
}

variable "vm_size" {
  type        = string
  description = "Tamaño de las VMs"
  default     = "Standard_B2ms"
}

variable "vm_count" {
  type        = number
  description = "Número de VMs de aplicación"
  default     = 2
}

variable "admin_username" {
  type        = string
  description = "Usuario administrador SSH"
  default     = "azureadmin"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Ruta a la clave pública SSH"
}
