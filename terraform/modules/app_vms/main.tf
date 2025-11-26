resource "azurerm_network_interface" "app_nic" {
  count               = var.vm_count
  name                = "${var.project_name}-app-nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.app_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    project = var.project_name
    env     = var.environment
  }

  depends_on = [var.app_subnet_id]
}

resource "azurerm_user_assigned_identity" "app_identity" {
  name                = "${var.project_name}-app-identity"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

resource "azurerm_linux_virtual_machine" "app_vm" {
  count               = var.vm_count
  name                = "${var.project_name}-app-vm-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.app_nic[count.index].id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.app_identity.id]
  }

  os_disk {
    name                 = "${var.project_name}-app-osdisk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
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

  depends_on = [
    azurerm_network_interface.app_nic,
    azurerm_user_assigned_identity.app_identity
  ]
}
