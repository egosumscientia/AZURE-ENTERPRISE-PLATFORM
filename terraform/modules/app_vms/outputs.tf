output "vm_private_ips" {
  value = [
    for nic in azurerm_network_interface.app_nic : nic.ip_configuration[0].private_ip_address
  ]
}

output "vm_ids" {
  value = [
    for vm in azurerm_linux_virtual_machine.app_vm : vm.id
  ]
}

output "identity_id" {
  value = azurerm_user_assigned_identity.app_identity.id
}

