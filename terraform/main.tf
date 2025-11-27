module "network" {
  source       = "./modules/network"
  project_name = var.project_name
  location     = var.location
  environment  = var.environment
}

module "bastion" {
  source              = "./modules/bastion"
  project_name        = var.project_name
  location            = var.location
  environment         = var.environment
  resource_group_name = module.network.resource_group_name

  bastion_subnet_id = module.network.bastion_subnet_id
}

resource "azurerm_network_interface" "jump_nic" {
  name                = "${var.project_name}-jump-nic"
  location            = var.location
  resource_group_name = module.network.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.network.subnets["automation"]
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
  resource_group_name = module.network.resource_group_name

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
  resource_group_name = module.network.resource_group_name
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

module "app_vms" {
  source       = "./modules/app_vms"
  project_name = var.project_name
  location     = var.location
  environment  = var.environment

  resource_group_name = module.network.resource_group_name
  app_subnet_id       = module.network.subnets["app"]
  ssh_public_key_path = var.ssh_public_key_path
}

module "application_gateway" {
  source              = "./modules/application_gateway"
  project_name        = var.project_name
  location            = var.location
  environment         = var.environment

  resource_group_name = module.network.resource_group_name
  public_subnet_id    = module.network.subnets["public"]

  backend_ips = module.app_vms.vm_private_ips
}

module "postgres" {
  source              = "./modules/postgres"
  project_name        = var.project_name
  location            = var.location
  environment         = var.environment
  resource_group_name = module.network.resource_group_name
  vnet_id             = module.network.vnet_id
  vnet_name = module.network.vnet_name
  data_subnet_id      = module.network.subnets["data"]
  admin_username = "pgadmin"
  admin_password = "123"
}

