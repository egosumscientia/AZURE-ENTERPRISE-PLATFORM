output "postgres_hostname" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "private_endpoint_ip" {
  value = azurerm_private_endpoint.postgres_pe.private_service_connection[0].private_ip_address
}

