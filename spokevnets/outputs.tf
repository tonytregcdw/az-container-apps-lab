output "vnet" {
  value = azurerm_virtual_network.spokevnet
}

output "snets" {
  value = module.spokesubnet.snets
}

output "subnetmap" {
  value = module.spokesubnet.subnetmap
}
