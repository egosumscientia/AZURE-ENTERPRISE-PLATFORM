resource "azurerm_network_interface" "jump_nic" {
  name                = "${var.project_name}-jump-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

resource "azurerm_network_security_group" "jump_nsg" {
  name                = "${var.project_name}-jump-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

resource "azurerm_network_interface_security_group_association" "jump_nic_assoc" {
  network_interface_id      = azurerm_network_interface.jump_nic.id
  network_security_group_id = azurerm_network_security_group.jump_nsg.id
}

resource "azurerm_linux_virtual_machine" "jump_vm" {
  name                = "${var.project_name}-jump"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = "azureadmin"

  network_interface_ids = [
    azurerm_network_interface.jump_nic.id
  ]

  admin_ssh_key {
    username   = "azureadmin"
    public_key = file(var.ssh_public_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    project = var.project_name
    env     = var.environment
  }
}
