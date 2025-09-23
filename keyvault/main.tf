# Random IDs for keyvault Resources
resource "random_id" "keyvault" {
  byte_length = 7
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  name                = "${var.code}-kv-${random_id.keyvault.hex}"
  provider            = azurerm
  location            = var.rg.location
  resource_group_name = var.rg.name
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  public_network_access_enabled = var.publicaccess
  network_acls {
    default_action = var.acl_default_action == null ? "Allow" : var.acl_default_action
    bypass = "AzureServices"
    ip_rules = var.allow_public_ip
  }
  tags = {
    Environment            = var.tag_Environment
    Application-Taxonomy   = "keyvault"
    Department             = var.tag_Department
    Geography              = var.region
    Terraform              = "Yes"
  }
}

resource "azurerm_key_vault_access_policy" "entra_groups" {
  for_each = var.entra_groups

  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id = each.value.object_id == null ? data.azurerm_client_config.current.object_id : each.value.object_id

  key_permissions = each.value.key_permissions
  secret_permissions = each.value.secret_permissions
  certificate_permissions = each.value.certificate_permissions
  storage_permissions = each.value.storage_permissions
}

module "keyvault_privateendpoint" {
    source = "../privateendpoint"
    for_each = var.private-endpoint
    name =  azurerm_key_vault.keyvault.name
    rg = var.rg
    providers = {
        azurerm = azurerm
        azurerm.dns = azurerm.dns
    }
    code = var.code
    regioncode = var.regioncode
    # vnet = each.value.vnet
    snet = each.value.snet
    dnszone = each.value.dnszone
    # sub-dns = each.value.sub-dns
    resourceid = azurerm_key_vault.keyvault.id
    subresource = each.value.dnsresourcetype
    tag_Department = var.tag_Department
    tag_Environment = var.tag_Environment
}

# resource "null_resource" "wait_for_dns" {
#   provisioner "local-exec" {
#     command = "sleep 60"  # Wait for for private DNS record to update
#   }

#   depends_on = [module.keyvault_privateendpoint.pe]
# }

#add logging if provided
resource "azurerm_monitor_diagnostic_setting" "logs" {
  count        = var.logging == null ? 0 : 1 
  name               = "logs-${azurerm_key_vault.keyvault.name}"
  target_resource_id =  azurerm_key_vault.keyvault.id
  log_analytics_workspace_id = var.logging.id
  enabled_log {
    category_group = "allLogs"
  }
  enabled_metric {
    category = "AllMetrics"
  }
}
