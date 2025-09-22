######################################
# Providers
######################################
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.39.0"
    }
    azapi = {
      source = "azure/azapi"
    }
  }
  required_version = "~> 1.12.0"
}
provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

# provider "azapi" {
#   enable_preflight = true
# }

terraform {
  backend "azurerm" {}
}

######################################
# Platform Providers
######################################
# Identity
provider "azurerm" {
  features {}
  alias           = "identity"
  subscription_id = var.sub-identity
  resource_provider_registrations = "none"
}

# Management
provider "azurerm" {
  features {}
  alias           = "management"
  subscription_id = var.sub-management
  resource_provider_registrations = "none"
}

provider "azapi" {
  alias           = "management"
  subscription_id = var.sub-management
}

# Connectivity
provider "azurerm" {
  features {}
  alias           = "connectivity"
  subscription_id = var.sub-connectivity
  resource_provider_registrations = "none"
}

# Applications environment
provider "azurerm" {
  features {}
  alias           = "app"
  subscription_id = var.sub-app
}
