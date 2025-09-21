
output "subnetmap" {
  value = local.subnetmap
}

output "snets" {
  value = azurerm_subnet.snet
}

# output "nsg" {
#   value = module.nsg.nsg
# }
