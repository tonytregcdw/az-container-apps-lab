######################################
# Connectivity
######################################


#spoke networks
module "spokevnets_r1_app" {
  source    = "./spokevnets"
  providers = {
    azurerm = azurerm.app
  }
  rg = azurerm_resource_group.r1_rg_app_01
  code = var.code
  vnet = var.region1-spoke-vnets["app${var.env}"]
  # vnetname = "${var.region1-spoke-vnets.apptest.name}"
  vnetname = var.region1-spoke-vnets["app${var.env}"].name
  usegateway = var.usegateway
  subnets = var.region1-snets["app${var.env}"]
  region = var.region1
  regioncode = var.region1code
  tag_Department = var.tag_Department
  tag_Environment = var.env
  dns-servers = var.dns-servers
  dns-ruleset = null
  hub_virtual_network_id = null
  sub-connectivity = var.sub-connectivity
}
