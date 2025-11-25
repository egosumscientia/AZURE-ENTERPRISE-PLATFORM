output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnets" {
  value = {
    public     = azurerm_subnet.public.id
    app        = azurerm_subnet.app.id
    data       = azurerm_subnet.data.id
    automation = azurerm_subnet.automation.id
  }
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion.id
}
