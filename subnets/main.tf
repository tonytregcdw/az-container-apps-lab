
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.1.0"
    }
  }
}

resource "azurerm_subnet" "snet" {
  for_each             = var.subnets
  name                 = each.key
  provider            = azurerm
  resource_group_name  = var.rg.name
  # resource_group_name  = var.vnet.resource_group_name
  # virtual_network_name = element(split("/", var.vnet_id), 8)
  virtual_network_name = var.vnet.name
  address_prefixes     = each.value.address_prefixes
  default_outbound_access_enabled = each.value.default_outbound_access_enabled != null ? each.value.default_outbound_access_enabled : false
  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", [])
    content {
      name = lookup(delegation.value, "name", null)
      dynamic "service_delegation" {
        for_each = lookup(delegation.value, "service_delegation", [])
        content {
          name    = lookup(service_delegation.value, "name", null)    # (Required) The name of service to delegate to. Possible values include Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.Databricks/workspaces, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Logic/integrationServiceEnvironments, Microsoft.Netapp/volumes, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.Web/hostingEnvironments and Microsoft.Web/serverFarms.
          actions = lookup(service_delegation.value, "actions", null) # (Required) A list of Actions which should be delegated. Possible values include Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action, Microsoft.Network/virtualNetworks/subnets/action and Microsoft.Network/virtualNetworks/subnets/join/action.
        }
      }
    }
  }
}

#create NSGs
module "nsg" {
  source = "../nsg"
  providers = {
    azurerm = azurerm
  }
  for_each = {
    for name, subnet in local.subnetmap : name => subnet
    if !(contains(["GatewaySubnet","AzureFirewallManagementSubnet","AzureBastionSubnet","AzureFirewallSubnet","RouteServerSubnet","AppGWSubnet"],name))
  }
  ruleset = each.value.nsg_ruleset
  rg = var.rg
  code = var.code
  regioncode = var.regioncode
  subnet = each.value
  tag_Environment = var.tag_Environment
  tag_Department = var.tag_Department
}

locals {
  #return subnet map variable appending newly created subnet id
  subnetmap = {
    for k, v in var.subnets : k => {
      name = azurerm_subnet.snet[k].name
      id = azurerm_subnet.snet[k].id
      address_prefixes = azurerm_subnet.snet[k].address_prefixes
      routetable = try(v.routetable, true)
      nsg_ruleset = try(v.nsg_ruleset, {})
      # vnet_id = var.vnet_id
      vnet_id = var.vnet.id
      # nsg = try(module.nsg[k].nsg, null)
    }
   }
}
