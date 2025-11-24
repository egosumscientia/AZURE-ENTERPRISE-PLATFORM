# ------------------------------------------------------
# Log Analytics Workspace
# ------------------------------------------------------
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.project_name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    project = var.project_name
    env     = var.environment
  }
}

# ------------------------------------------------------
# Diagnostic Settings - Application Gateway
# ------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "diag_agw" {
  name                       = "${var.project_name}-diag-agw"
  target_resource_id         = var.application_gateway_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "LinuxSyslog"
  }

  enabled_log {
    category = "LinuxSyslog"
  }

  enabled_log {
    category = "LinuxSyslog"
  }

}

# ------------------------------------------------------
# Diagnostic Settings - Virtual Machines
# ------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "diag_vms" {
  count                     = length(var.vm_ids)
  name                      = "${var.project_name}-diag-vm-${count.index}"
  target_resource_id        = var.vm_ids[count.index]
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "LinuxSyslog"
  }

  enabled_log {
    category = "LinuxSyslog"
  }

}

# ------------------------------------------------------
# Diagnostic Settings - PostgreSQL Flexible Server
# ------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "diag_postgres" {
  name                       = "${var.project_name}-diag-postgres"
  target_resource_id         = var.postgres_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "LinuxSyslog"
  }

  enabled_log {
    category = "LinuxSyslog"
  }

  enabled_log {
    category = "LinuxSyslog"
  }

}

