
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.code}-nsg-${var.regioncode}-${var.subnet.name}"
  provider            = azurerm
  location            = var.rg.location
  resource_group_name = var.rg.name
  tags = {
    Environment            = var.tag_Environment
    Department             = var.tag_Department
    Application-Taxonomy   = "Security"
    Geography              = var.rg.location
    Terraform              = "Yes"
  }
}

resource "azurerm_network_security_rule" "nsgrule" {
  for_each = var.ruleset
  name                       = each.key
  priority                   = each.value.priority
  direction                  = each.value.direction
  access                     = each.value.access
  protocol                   = each.value.protocol
  source_port_range          = each.value.source_port_range 
  destination_port_range     = each.value.destination_port_range
  destination_port_ranges     = each.value.destination_port_ranges
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix
  resource_group_name         = var.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg-ass" {
  subnet_id            = var.subnet.id
  provider             = azurerm
  network_security_group_id = azurerm_network_security_group.nsg.id
}
