resource "azurerm_log_analytics_workspace" "r1_logs_app_01" {
  name                = "${var.code}-logs-${var.region1code}-app-${var.env}-01"
  location            = var.region1
  provider            = azurerm.app
  resource_group_name = azurerm_resource_group.r1_rg_app_01.name
  sku                 = "PerGB2018"
  retention_in_days   = 90
  tags = {
    Environment            = var.env
    Application-Taxonomy   = "Logging"
    IT-Owner-Contact       = var.tag_IT-Owner-Contact
    Business-Owner-Contact = var.tag_Business-Owner-Contact
    Department             = var.tag_Department
    Hours-Operational      = var.tag_Hours-Operational
    Days-Operational       = var.tag_Days-Operational
    Billed-To              = var.tag_Billed-To
    Cost-Centre            = var.tag_Cost-Centre
    Geography              = var.region1
    Terraform              = "Yes"
  }
}
