output "jump_public_ip" {
  value = azurerm_public_ip.jump_ip.ip_address
}

output "jump_private_ip" {
  value = azurerm_network_interface.jump_nic.private_ip_address
}
