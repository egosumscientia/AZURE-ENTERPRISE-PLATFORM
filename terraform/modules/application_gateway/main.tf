# ------------------------------------------------------
# Public IP para Application Gateway
# ------------------------------------------------------
resource "azurerm_public_ip" "agw_ip" {
  name                = "${var.project_name}-agw-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

# ------------------------------------------------------
# Application Gateway
# ------------------------------------------------------
resource "azurerm_application_gateway" "agw" {
  name                = "${var.project_name}-agw"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = var.agw_capacity
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.public_subnet_id
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.agw_ip.id
  }

  frontend_port {
    name = "frontend-port-80"
    port = 80
  }

  frontend_port {
    name = "frontend-port-443"
    port = 443
  }

  backend_address_pool {
    name  = "app-backend-pool"
    fqdns = []
    ip_addresses = var.backend_ips
  }

  backend_http_settings {
    name                  = "app-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "listener-http"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "frontend-port-80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule-http"
    rule_type                  = "Basic"
    http_listener_name         = "listener-http"
    backend_address_pool_name  = "app-backend-pool"
    backend_http_settings_name = "app-http-settings"
    priority                    = 100
  }

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

