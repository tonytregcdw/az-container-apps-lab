output "kv" {
    value = azurerm_key_vault.keyvault
}

output "pe" {
    value = module.keyvault_privateendpoint
}

output "entra_groups" {
    value = azurerm_key_vault_access_policy.entra_groups
}