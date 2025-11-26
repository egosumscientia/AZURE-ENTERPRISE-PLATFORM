#############################################
# PRIVATE DNS ZONE PARA POSTGRES FLEX INJECTED
#############################################
resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dns_link" {
  name                  = "postgres-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

#############################################
# SUBNET DELEGADA PARA POSTGRES FLEX SERVER
#############################################
resource "azurerm_subnet" "postgres_subnet" {
  name                 = "postgres-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = ["10.10.6.0/24"]

  delegation {
    name = "postgres-delegation"
    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

#############################################
# POSTGRESQL FLEX SERVER (INJECTED MODE REAL)
#############################################
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                         = "${var.project_name}-postgres"
  resource_group_name          = var.resource_group_name
  location                     = var.location

  administrator_login          = var.admin_username
  administrator_password       = var.admin_password

  sku_name                     = var.sku_name
  version                      = "16"
  storage_mb                   = 32768

  delegated_subnet_id          = azurerm_subnet.postgres_subnet.id
  private_dns_zone_id          = azurerm_private_dns_zone.postgres_dns.id
  public_network_access_enabled = false

  tags = {
    project = var.project_name
    env     = var.environment
  }

  depends_on = [
    azurerm_private_dns_zone.postgres_dns,
    azurerm_subnet.postgres_subnet,
    azurerm_private_dns_zone_virtual_network_link.postgres_dns_link
  ]
}
