# Private DNS Zone
resource "azurerm_private_dns_zone" "postgres_dns" {
  name                = "${var.project_name}.postgres.database.azure.com"
  resource_group_name = var.resource_group_name

  tags = {
    project = var.project_name
    env     = var.environment
  }

  depends_on = [var.vnet_id]  # forzar que VNet exista
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dns_link" {
  name                  = "${var.project_name}-postgres-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_dns.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false

  depends_on = [azurerm_private_dns_zone.postgres_dns, var.vnet_id]
}

# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                         = "${var.project_name}-postgres"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  administrator_login          = var.admin_username
  administrator_password       = var.admin_password
  storage_mb                   = 32768
  sku_name                      = var.sku_name
  version                       = "15"
  delegated_subnet_id           = var.data_subnet_id
  private_dns_zone_id           = azurerm_private_dns_zone.postgres_dns.id
  public_network_access_enabled = false

  high_availability {
    mode = "ZoneRedundant"
  }

  tags = {
    project = var.project_name
    env     = var.environment
  }

  depends_on = [
    var.data_subnet_id,
    azurerm_private_dns_zone.postgres_dns
  ]
}

# Private Endpoint
resource "azurerm_private_endpoint" "postgres_pe" {
  name                = "${var.project_name}-postgres-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.data_subnet_id

  private_service_connection {
    name                           = "postgres-pe-connection"
    private_connection_resource_id = azurerm_postgresql_flexible_server.postgres.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }

  tags = {
    project = var.project_name
    env     = var.environment
  }

  depends_on = [
    azurerm_postgresql_flexible_server.postgres,
    var.data_subnet_id
  ]
}
