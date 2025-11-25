resource "azurerm_network_interface" "jump_nic" {
  name                = "${var.project_name}-jump-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jump_ip.id
  }

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

resource "azurerm_public_ip" "jump_ip" {
  name                = "${var.project_name}-jump-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

resource "azurerm_network_security_group" "jump_nsg" {
  name                = "${var.project_name}-jump-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-ssh-from-home"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.admin_ip   # ← tu IP
    destination_address_prefix = "*"
  }

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

resource "azurerm_subnet_network_security_group_association" "jump_assoc" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.jump_nsg.id
}

resource "azurerm_linux_virtual_machine" "jump_vm" {
  name                = "${var.project_name}-jump"
  resource_group_name = azurerm_resource_group.rg.name
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
