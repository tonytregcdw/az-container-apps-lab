#module routes - creates route tables and associates to each spoke subnet

#route table

resource "azurerm_route_table" "routetable" {
  name                = "${var.code}-routetable-${var.regioncode}-${var.vnet.name}"
  location            = var.region
  resource_group_name = var.rg
  bgp_route_propagation_enabled = try(var.enablebgp,false)

  tags = {
    Application-Taxonomy   = "route"
    Geography              = var.region
    Environment            = var.tag_Environment
    Department             = var.tag_Department
    Owner                  = var.tag_Department
    Terraform              = "Yes"
  }
}

resource "azurerm_route" "routes" {
  for_each = var.vnet.routes
  name           = "${var.code}-route-${var.regioncode}-${each.key}"
  resource_group_name = var.rg
  route_table_name    = azurerm_route_table.routetable.name
  address_prefix = each.value.address_prefix
  next_hop_type  = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_type == "VirtualAppliance" ? var.gatewayip : null
}

resource "azurerm_subnet_route_table_association" "route" {
  for_each = {
    for k, v in var.subnets : k => v
    if try(v.routetable, true)
  }
  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.routetable.id
}
