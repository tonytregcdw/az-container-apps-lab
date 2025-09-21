terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.1.0"
    }
  }
}

#-------------------------------------
# hub Provider Alias for Peering
#-------------------------------------
provider "azurerm" {
  alias           = "hub"
  subscription_id = var.sub-connectivity
  resource_provider_registrations = "none"
  # subscription_id = element(split("/", var.hub_virtual_network_id), 2)
  features {}
}
