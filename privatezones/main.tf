resource "azurerm_private_dns_zone" "zone" {
  provider = azurerm
  name                = var.zone
  resource_group_name = var.rg
  tags = {
    Application-Taxonomy   = "DNS"
    Environment            = var.tag_Environment
    Department             = var.tag_Department
    Terraform              = "Yes"
  }
}

resource "azurerm_private_dns_a_record" "records" {
  for_each = var.records
  name                = each.key
  zone_name           = azurerm_private_dns_zone.zone.name
  resource_group_name = var.rg
  ttl                 = 10
  records             = [each.value]
}


resource "azurerm_private_dns_zone_virtual_network_link" "links" {
  for_each = var.vnets
  name                  = "dnslink-${each.value.name}"
  resource_group_name   = var.rg
  private_dns_zone_name = azurerm_private_dns_zone.zone.name
  virtual_network_id    = each.value.id
  tags = {
    Application-Taxonomy   = "DNS"
    Environment            = var.tag_Environment
    Department             = var.tag_Department
    Terraform              = "Yes"
  }
}

