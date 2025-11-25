resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-rg"
  location = var.location

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.10.0.0/16"]

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

# -------------------------------
# Subnets
# -------------------------------

resource "azurerm_subnet" "public" {
  name                 = "${var.project_name}-snet-public"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_subnet" "app" {
  name                 = "${var.project_name}-snet-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.2.0/24"]
}

resource "azurerm_subnet" "data" {
  name                 = "${var.project_name}-snet-data"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.3.0/24"]

  delegation {
    name = "postgresql-flexible-server-delegation"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"
      ]
    }
  }
}

resource "azurerm_subnet" "automation" {
  name                 = "${var.project_name}-snet-automation"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.4.0/24"]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.5.0/24"]
}

# ------------------------------------------------------
# NSGs (Zero-Trust: todo bloqueado excepto tráfico necesario)
# ------------------------------------------------------

resource "azurerm_network_security_group" "public_nsg" {
  name                = "${var.project_name}-nsg-public"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "${var.project_name}-nsg-app"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

resource "azurerm_network_security_group" "data_nsg" {
  name                = "${var.project_name}-nsg-data"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

resource "azurerm_network_security_group" "automation_nsg" {
  name                = "${var.project_name}-nsg-automation"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

# ---------------------------
# NSG Rules
# ---------------------------

# PUBLIC: permite solo tráfico HTTPS entrante
resource "azurerm_network_security_rule" "public_https_in" {
  name                        = "allow-https-in"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.public_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

# APP: permite tráfico desde Application Gateway
resource "azurerm_network_security_rule" "app_from_public" {
  name                        = "public-to-app"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefix       = "10.10.1.0/24"
  source_port_range           = "*"
  destination_port_range      = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.app_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

# DATA: permite solo tráfico desde APP (Zero-Trust)
resource "azurerm_network_security_rule" "data_from_app" {
  name                        = "app-to-data"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_address_prefix       = "10.10.2.0/24"
  source_port_range           = "*"
  destination_port_range      = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.data_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

# AUTOMATION: permite SSH desde Bastion y salida a todos
resource "azurerm_network_security_rule" "automation_ssh" {
  name                        = "allow-ssh-from-bastion"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_address_prefix       = "10.10.1.0/24"
  source_port_range           = "*"
  destination_port_range      = "22"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.automation_nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "agw_inbound_required" {
  name                        = "allow-agw-required-ports"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["65200-65535"]
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.public_nsg.name
}

# -----------------------------------
# Asociar NSGs a las Subnets
# -----------------------------------

resource "azurerm_subnet_network_security_group_association" "app_assoc" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "data_assoc" {
  subnet_id                 = azurerm_subnet.data.id
  network_security_group_id = azurerm_network_security_group.data_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "automation_assoc" {
  subnet_id                 = azurerm_subnet.automation.id
  network_security_group_id = azurerm_network_security_group.automation_nsg.id
}

