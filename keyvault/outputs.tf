output "kv" {
    value = azurerm_key_vault.keyvault
}

output "pe" {
    value = module.keyvault_privateendpoint
}
