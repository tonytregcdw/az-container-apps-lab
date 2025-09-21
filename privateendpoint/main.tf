
# Create Private Endpoints
resource "azurerm_private_endpoint" "pe" {
  name                = "pe-${var.name}"
  provider            = azurerm
  location            = var.rg.location
  resource_group_name = var.rg.name
  subnet_id           = var.snet.id

  dynamic "ip_configuration" {
    for_each = var.static_private_ip == null ? [] : [1]
    content {
      name                       = "static-ip"
      private_ip_address         = var.static_private_ip
      subresource_name           = var.subresource[0]
    }
  }

  private_service_connection {
    name                           = "psc-${var.name}"
    private_connection_resource_id = var.resourceid
    is_manual_connection           = false
    subresource_names              = var.subresource
  }
  private_dns_zone_group {
    name                           = "default"
    private_dns_zone_ids           = [for zone in values(var.dnszone) : zone.id]
  }
  tags = {
    Environment            = var.tag_Environment
    Application-Taxonomy   = "private endpoint"
    Department             = var.tag_Department
    Geography              = var.rg.location
    Terraform              = "Yes"
  }
}

