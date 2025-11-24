 output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnets" {
  value = {
    public     = azurerm_subnet.public.id
    app        = azurerm_subnet.app.id
    data       = azurerm_subnet.data.id
    automation = azurerm_subnet.automation.id
  }
}

