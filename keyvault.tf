
#Create key vaults
module "r1_keyvault_app_01" {
  source    = "./keyvault"
  providers = {
    azurerm = azurerm.app
    azurerm.dns = azurerm.identity
  }
  rg = azurerm_resource_group.r1_rg_app_appservices_01
  code = var.code
  region = var.region1
  publicaccess = true
  # allow_public_ip = ["4.0.0.0/8","9.0.0.0/8","13.0.0.0/8","20.0.0.0/8","23.0.0.0/8","40.0.0.0/8","48.0.0.0/8","50.0.0.0/8","51.0.0.0/8","52.0.0.0/8","57.0.0.0/8","64.0.0.0/8","65.0.0.0/8","68.0.0.0/8","70.0.0.0/8","72.0.0.0/8","74.0.0.0/8","94.0.0.0/8","98.0.0.0/8","104.0.0.0/8","108.0.0.0/8","128.0.0.0/8","130.0.0.0/8","131.0.0.0/8","132.0.0.0/8","134.0.0.0/8","135.0.0.0/8","137.0.0.0/8","138.0.0.0/8","145.0.0.0/8","151.0.0.0/8","157.0.0.0/8","168.0.0.0/8","172.0.0.0/8","191.0.0.0/8","193.0.0.0/8","199.0.0.0/8","204.0.0.0/8","207.0.0.0/8","209.0.0.0/8","213.0.0.0/8"]
  acl_default_action = "Deny"
  regioncode = var.region1code
  tag_Department = var.tag_Department
  tag_Environment = var.env
  logging = azurerm_log_analytics_workspace.r1_logs_app_01
  entra_groups = var.keyvault-access["${var.env}"]
  private-endpoint = {}
}


# Create Managed user identities

#appgw
resource "azurerm_user_assigned_identity" "userid_appgw_01" {
  name                        = "${var.code}-userid-${var.region1code}-appgw-${var.env}-01"
  provider                    = azurerm.app
  resource_group_name         = azurerm_resource_group.r1_rg_app_01.name
  location                    = azurerm_resource_group.r1_rg_app_01.location
  tags = {
    Environment            = var.env
    Application-Taxonomy   = "applications"
    Department             = var.tag_Department
    Geography              = var.region1
    Terraform              = "Yes"
  }
}

resource "azurerm_key_vault_access_policy" "userid_appgw_01_access_kv_app_01" {
  key_vault_id = module.r1_keyvault_app_01.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.userid_appgw_01.principal_id

    key_permissions = []
    secret_permissions = []
    storage_permissions = []
    certificate_permissions = [
      "Get",
      "GetIssuers",
      "List",
      "ListIssuers",
    ]
}


#app1
resource "azurerm_user_assigned_identity" "userid_app_01" {
  name                        = "${var.code}-userid-${var.region1code}-app-${var.env}-01"
  provider                    = azurerm.app
  resource_group_name         = azurerm_resource_group.r1_rg_app_appservices_01.name
  location                    = azurerm_resource_group.r1_rg_app_appservices_01.location
  tags = {
    Environment            = var.env
    Application-Taxonomy   = "applications"
    Department             = var.tag_Department
    Geography              = var.region1
    Terraform              = "Yes"
  }
}

resource "azurerm_key_vault_access_policy" "userid_app_01_access" {
  key_vault_id = module.r1_keyvault_app_01.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.userid_app_01.principal_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get"
    ]

    storage_permissions = [
      "Get",
    ]

    certificate_permissions = [
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "SetIssuers",
      "Update",
    ]
}




# #app secrets
# resource "azurerm_key_vault_secret" "app_container_token" {
#   name         = "CONTAINER-TOKEN"
#   provider     = azurerm.app
#   value        = var.container_token
#   key_vault_id = module.r1_keyvault_app_01.kv.id
# }

# resource "azurerm_key_vault_secret" "app_db_pass" {
#   name         = "DB-PASS"
#   provider     = azurerm.app
#   value        = var.db_pass
#   key_vault_id = module.r1_keyvault_app_01.kv.id
# }

# resource "azurerm_key_vault_secret" "app_abi_sftp_user" {
#   name         = "ABI-SFTP-USER"
#   provider     = azurerm.app
#   value        = var.abi_sftp_user
#   key_vault_id = module.r1_keyvault_app_01.kv.id
# }

# resource "azurerm_key_vault_secret" "app_abi_sftp_password" {
#   name         = "ABI-SFTP-PASSWORD"
#   provider     = azurerm.app
#   value        = var.abi_sftp_password
#   key_vault_id = module.r1_keyvault_app_01.kv.id
# }

