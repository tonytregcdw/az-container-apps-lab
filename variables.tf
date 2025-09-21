######################################
# Variables
######################################
# Core Naming
variable "code" {
  type        = string
  description = "Customer code used for creation of some resources"
}

#subscriptions
variable "sub-identity" {
  description = "sub-identity"
  type = string
}
variable "sub-connectivity" {
  description = "sub-connectivity"
  type = string
}
variable "sub-management" {
  description = "sub-management"
  type = string
}
variable "sub-app-prod" {
  description = "sub-app-prod"
  type = string
}
variable "sub-app-test" {
  description = "sub-app-test"
  type = string
}

variable "sub-app" {
  description = "sub-app"
  type = string
}

#Management groups
variable "mg-root" {
  description = "mg-root"
  type = string
  default = "Tenant Root Group"
}

variable "mg-root-id" {
  description = "root management group UUID"
  type = string
  default = "00000000-0000-0000-0000-000000000000"
}

variable "mg-prod-id" {
  description = "mg-prod"
  type = string
  default = "mg-prod"
}

variable "mg-applications" {
  description = "mg-applications"
  type = string
  default = "mg-applications"
}

variable "mg-devtest" {
  description = "mg-devtest"
  type = string
  default = "mg-devtest"
}

# Locations
variable "region1" {
  type        = string
  description = "Region 1 in format as per Azure CLI"
}
variable "region2" {
  type        = string
  description = "Region 2 in format as per Azure CLI"
}
variable "region1code" {
  type        = string
  description = "Region 1 in code format used for Resource Naming"
}
variable "region2code" {
  type        = string
  description = "Region 2 in code format used for Resource Naming"
}
variable "regions" {
  type        = list
  description = "regions"
}

# Tags
variable "tag_EnvironmentPROD" {
  type        = string
  description = "Tag for Environment when Resource is Production"
  default = "PRODUCTION"
}
variable "tag_EnvironmentDEV" {
  type        = string
  description = "Tag for Environment when Resource is Development"
  default = "DEV"
}
variable "tag_EnvironmentUAT" {
  type        = string
  description = "Tag for Environment when Resource is UAT"
  default = "UAT"
}
variable "tag_IT-Owner-Contact" {
  type        = string
  description = "IT Owner Contact Tag"
}
variable "tag_Business-Owner-Contact" {
  type        = string
  description = "Business Owner Contact Tag"
}
variable "tag_Department" {
  type        = string
  description = "Department Tag"
}

variable "tag_Hours-Operational" {
  type        = string
  description = "Hours Operational Tag"
}
variable "tag_Days-Operational" {
  type        = string
  description = "Day Operational Tag"
}
variable "tag_Billed-To" {
  type        = string
  description = "Billed To Tag"
}
variable "tag_Cost-Centre" {
  type        = string
  description = "Cost Center Tag"
}
variable "tag_Terraform" {
  type        = string
  description = "Tag applied to Resources Created by Terraform"
}

#Environment

variable "env" {
  type = string
  description = "Environment"
  default = "test"
}

variable "app1" {
  type = string
  description = "Application code"
  default = "app01"
}

variable "app2" {
  type = string
  description = "Application code"
  default = "app02"
}

# Networking

variable "usegateway" {
  type = bool
}

variable "gatewayip" {
  type = string
}


variable "region1-cidr" {
  type        = string
  description = "Region 1 CIDR Range"
  default = "10.10.0.0/16"
}

variable "region2-cidr" {
  type        = string
  description = "Region 2 CIDR Range"
  default = "10.11.0.0/16"
}

variable "region1-hub-vnets" {
  description = "hub vnet Map for Creation"
  type = map
  default = {
    hub = {
      address_space = "10.10.0.0/21"
    }
  }
}

variable "region2-hub-vnets" {
  description = "hub vnet Map for Creation"
  type = map
  default = {
    hub = {
      address_space = "10.11.0.0/21"
    }
  }
}

variable "region1-spoke-vnets" {
  description = "spoke vnet Map for Creation"
  type = map
  default = {
    identity = {
      name = "identity"
      address_space = "10.10.16.0/23"
    }
    avd = {
      name = "avd"
      address_space = "10.10.18.0/23"
    }
    apps = {
      name = "apps"
      address_space = "10.10.24.0/21"
    }
    devtest = {
      name = "devtest"
      address_space = "10.10.20.0/22"
    }
    cognitive = {
      name = "cognitive"
      address_space = "10.10.32.0/23"
    }
    management = {
      name = "management"
      address_space = "10.10.34.0/23"
    }
  }
}

variable "region2-spoke-vnets" {
  description = "spoke vnet Map for Creation"
  type = map
  default = {
    identity = {
      name = "identity"
      address_space = "10.11.16.0/23"
    }
    avd = {
      name = "avd"
      address_space = "10.11.18.0/23"
    }
    apps = {
      name = "apps"
      address_space = "10.11.24.0/21"
    }
    devtest = {
      name = "devtest"
      address_space = "10.11.20.0/22"
    }
  }
}

variable "region1-snets" {
  description = "Hub Subnet Map for Creation"
  type = any
}


variable "vnetsdata" {
  description = "Existing vnet map for data sources"
  type = any
}

variable "resourcegroupsdata" {
  description = "Existing resource group map for data sources"
  type = any
}

variable "logsdata" {
  description = "Existing log analytics data source"
  type = any
}

variable "r1-gateway" {
  description = "r2 default gateway, if no virtual appliance is created"
  type = string
  default = "10.10.10.1"
}

variable "r2-gateway" {
  description = "r2 default gateway, if no virtual appliance is created"
  type = string
  default = "10.11.10.1"
}

variable "app-gateways" {
  type = map
  default = {
    "r101" = {
      "name" = "app01"
      "ip" = "10.10.13.10"
      "protocol" = "Https"
      "port" = 443
    }
    "r102" = {
      "name" = "app02"
      "ip" = "10.10.13.11"
      "protocol" = "Https"
      "port" = 443
    }
  }
}


variable "sqlserver" {
  description = "sqlserver map for creation"
  type = any
}

variable "sqldb" {
  description = "sqldb map for creation"
  type = any
}

variable "redis" {
  description = "redis map for creation"
  type = any
}


variable "vm-dc" {
  type = map
  default = {
    "r101" = {
      "name" = "VMAZ-DC01"
      "ip" = "10.10.16.10"
    }
    "r102" = {
      "name" = "VMAZ-DC02"
      "ip" = "10.10.16.11"
    }
    "r201" = {
      "name" = "VMAZ-DC03"
      "ip" = "10.11.16.10"
    }
    "r202" = {
      "name" = "VMAZ-DC04"
      "ip" = "10.11.16.11"
    }
  }
}

variable "r1-createfw" {
  description = "toggle firewall creation"
  type   = bool
  default = false
}

variable "r2-createfw" {
  description = "toggle firewall creation"
  type   = bool
  default = false
}

variable "r1-createvng" {
  description = "toggle vpn creation"
  type   = bool
  default = false
}

variable "r2-createvng" {
  description = "toggle vpn creation"
  type   = bool
  default = false
}

variable "r1-createbastion" {
  description = "toggle bastion creation"
  type   = bool
  default = false
}

variable "r2-createbastion" {
  description = "toggle bastion creation"
  type   = bool
  default = false
}

variable "onpremise-dc1-cidr" {
  description = "onpremise DC1 ip range"
  type = list
  default = ["10.100.0.0/16"]
}

variable "dns-servers" {
  description = "DNS servers"
  type = list
}

variable "dnszones_mgmt_enabled" {
  description = "DNS servers"
  type = bool
  default = false
}

variable "dnszones_identity_enabled" {
  description = "DNS servers"
  type = bool
  default = true
}

variable "privatednszones" {
  description = "DNZ zone map for creation"
  type = map
  default = {
    "privatelink.adf.azure.com" = {
    }
    "privatelink.azurecr.io" = {
    }
    # "privatelink.blob.core.windows.net" = {
    # }
    "privatelink.database.windows.net" = {
    }
    # "privatelink.dfs.core.windows.net" = {
    # }
    # "privatelink.file.core.windows.net" = {
    # }
    # "privatelink.vaultcore.azure.net" = {
    # }
    # "privatelink.uks.backup.core.windows.net" = {
    # }
    "privatelink.queue.core.windows.net" = {
    }
    # "privatelink.siterecovery.windowsazure.com" = {
    # }
    "privatelink.openai.azure.com" = {
    }
    "privatelink.azure-api.net" = {
    }
    "privatelink.azurewebsites.net" = {
    }
  }
}

variable "vmmgmt" {
  type = map
  default = {
    "prod-vm-01" = {
      "name" = "AZVTESTM01"
      "size" = "Standard_DS1_v2"
      "avzone" = 1
      "tagenvironment" = "Test"
      "tagapplicationtaxonomy" = "Test"
      "tagowner" = "LandingZone"
      "disktype" = "StandardSSD_LRS"
      "image" = {
        "publisher" = "MicrosoftWindowsServer"
        "offer" = "WindowsServer"
        "sku" = "2019-Datacenter"
        "version" = "latest"
      }
    }
  }
}


variable "vmidentity" {
  type = map
  default = {
    "prod-vm-01" = {
      "name" = "AZVTESTM02"
      "size" = "Standard_DS1_v2"
      "avzone" = 1
      "tagenvironment" = "Test"
      "tagapplicationtaxonomy" = "Test"
      "tagowner" = "LandingZone"
      "disktype" = "StandardSSD_LRS"
      "image" = {
        "publisher" = "MicrosoftWindowsServer"
        "offer" = "WindowsServer"
        "sku" = "2019-Datacenter"
        "version" = "latest"
      }
    }
  }
}

variable "keyvault-access" {
  default = {}
}

variable "apimgmt" {
  description = "API mgmt Map for Creation"
  type = any
}

variable "container_user" {
  description = "user for container registry"
  type = string
  sensitive = true
}

variable "container_token" {
  description = "token for container registry"
  type = string
  sensitive = true
}

variable "db_pass" {
  description = "password for test database"
  type = string
  sensitive = true
}

variable "abi_sftp_user" {  
  description = "user for abi sftp"
  type = string
  sensitive = true
}

variable "abi_sftp_password" {
  description = "password for abi sftp"
  type = string
  sensitive = true
}

# variable "azure_storage_connection" {
#   description = "SAS for storage account"
#   type = string
#   sensitive = true
# }

# variable "key_vault_test_secrets" {
#   type = map(string)
#   description = "Map of secret names to secret values."
# }


# variable "containerappenv" {
#   description = "container app environment map for creation"
#   type = any
# }

variable "containerapp" {
  description = "container app for creation"
  type = any
}

variable "cae" {
  description = "container app for creation"
  type = any
}

variable "linux-vm" {
  description = "map for Linux VM creation"
  type = any
  default = {}
}

variable "appgw" {
  description = "map for app gateway creation"
  type = any
  default = {}
}

variable "postgresdb" {
  description = "Postgres DB map for creation"
  type = any
}
