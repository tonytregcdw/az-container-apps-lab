
module "r1_routes_app" {
  source = "./routes"
  providers = {
    azurerm = azurerm.app
  }
  gatewayip = try(var.gatewayip,"10.10.10.10")
  subnets = module.spokevnets_r1_app.subnetmap
  vnet = var.region1-spoke-vnets["app${var.env}"]
  rg = azurerm_resource_group.r1_rg_app_01.name
  # rg = data.region1_apptest.resource_group_name
  name = "app${var.env}"
  enablebgp = false
  region = var.region1
  regioncode = var.region1code
  code = var.code
  tag_Department = var.tag_Department
  tag_Environment = var.env
}
