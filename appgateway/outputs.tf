
#outputs
output "appgw-fw-public-ip" {
  value = azurerm_public_ip.appgw-pip-01
}

output "appgw" {
  value = azurerm_application_gateway.appgw
}
