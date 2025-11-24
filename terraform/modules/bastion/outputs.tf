output "bastion_public_ip" {
  value = azurerm_public_ip.bastion_ip.ip_address
}

output "bastion_id" {
  value = azurerm_bastion_host.bastion.id
}

