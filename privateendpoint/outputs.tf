output "pe" {
    value = azurerm_private_endpoint.pe
}

output "peip" {
    value = azurerm_private_endpoint.pe.private_service_connection[0].private_ip_address
}

output "pedns" {
    value = azurerm_private_endpoint.pe.custom_dns_configs
}
