# Create Private DNS Zone Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "dnslink" {
  name                = "dnslink-${var.vnet.name}"
  provider            = azurerm.dns
  resource_group_name = var.rg
  private_dns_zone_name = var.dnszone
  virtual_network_id    = var.vnet.id
  tags = {
    Environment            = var.tag_Environment
    Application-Taxonomy   = "DNS"
    Department             = var.tag_Department
    Terraform              = "Yes"
  }
}

