
module "storage_r1_01" {
  source    = "./storage"
  providers = {
    azurerm = azurerm.app
    azurerm.dns = azurerm.identity
  }
  name = "${var.code}st${var.region1code}pos${var.env}1"
  rg = azurerm_resource_group.r1_rg_app_appservices_01
  code = var.code
  region = var.region1
  kind = "StorageV2"
  tier = "Standard"
  replication = "LRS"
  publicaccess = false
  blobanonymousaccess = false
  shared_access_key_enabled = true
  regioncode = var.region1code
  tag_Department = var.tag_Department
  tag_Environment = var.env
  private-endpoint = {}
}
