

data "azurerm_client_config" "current" {}

# data "azurerm_resources" "vnets" {
#   type = "Microsoft.Network/virtualNetworks"
#   provider = azurerm.connectivity
# }

# #Hub network
# data "azurerm_virtual_network" "region1_hub" {
#   provider = azurerm.connectivity
#   name = var.vnetsdata.hub.name
#   resource_group_name = var.vnetsdata.hub.rg
# }

# #Identity network
# data "azurerm_virtual_network" "region1_identity" {
#   provider = azurerm.identity
#   name = var.vnetsdata.identity.name
#   resource_group_name = var.vnetsdata.identity.rg
# }


# public IP of terraform deployment agent
data "external" "my_public_ip" {
  program = ["bash", "-c", "curl -s 'https://ipinfo.io/json' | jq -r '{ip: .ip}'"]
}


data "azurerm_resources" "dnszones" {
  type = "Microsoft.Network/privateDnsZones"
  provider = azurerm.identity
}

# #data - r1 identity dns rg
# data "azurerm_resource_group" "rg_dns" {
#   name = var.resourcegroupsdata.dns.name
#   provider = azurerm.identity
# }

# data "azurerm_resource_group" "rg_management" {
#   name = var.resourcegroupsdata.management.name
#   provider = azurerm.management
# }


locals {
  dnszones = {
    for obj in data.azurerm_resources.dnszones.resources : obj.name => obj
  }
}

# # Logging
# data "azurerm_log_analytics_workspace" "logs" {
#   name = var.logsdata.management.name
#   resource_group_name = var.logsdata.management.rg
#   provider = azurerm.management
# }
