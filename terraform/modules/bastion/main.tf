# -----------------------------------------
# Bastion Public IP
# -----------------------------------------
resource "azurerm_public_ip" "bastion_ip" {
  name                = "${var.project_name}-bastion-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

# -----------------------------------------
# Azure Bastion Host
# -----------------------------------------
resource "azurerm_bastion_host" "bastion" {
  name                = "${var.project_name}-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.bastion_subnet_id   # ← CORREGIDO
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }

  tags = {
    project = var.project_name
    env     = var.environment
  }
}
