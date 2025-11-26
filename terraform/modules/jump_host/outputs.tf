output "jump_vm_id" {
  value = azurerm_linux_virtual_machine.jump_vm.id
}

output "jump_private_ip" {
  value = azurerm_network_interface.jump_nic.private_ip_address
}
