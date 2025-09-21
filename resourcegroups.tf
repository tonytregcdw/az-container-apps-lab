

resource "azurerm_resource_group" "r1_rg_app_01" {
  name     = "${var.code}-rg-${var.region1code}-app-${var.env}-01"
  provider = azurerm.app
  location = var.region1
  tags = {
    Environment            = var.env
    Application-Taxonomy   = "applications"
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


resource "azurerm_resource_group" "r1_rg_app_appservices_01" {
  name     = "${var.code}-rg-${var.region1code}-${var.env}-appservices-01"
  provider = azurerm.app
  location = var.region1
  tags = {
    Environment            = var.env
    Application-Taxonomy   = "applications"
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
