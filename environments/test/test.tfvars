######################################
# Variables
######################################

#subscriptions
sub-identity = "a2d3df79-3372-479d-83b8-7140c9f56b5c"
sub-connectivity = "a2d3df79-3372-479d-83b8-7140c9f56b5c"
sub-management = "a2d3df79-3372-479d-83b8-7140c9f56b5c"
sub-app = "a2d3df79-3372-479d-83b8-7140c9f56b5c"

# Core Naming
code = "lab"

#Management groups
tenant-root-group = "Tenant Root Group"
mg-root-id = "mg-root"
mg-prod-id = "mg-prod"
mg-applications = "mg-apps"
mg-devtest = "mg-test"


# Locations
region1     = "UK South"
region2     = "UK West"
region1code = "uks"
region2code = "ukw"
regions = ["UK South", "UK West"]

# Tags
tag_EnvironmentPROD        = "Production"
tag_EnvironmentDEV         = "Development"
tag_EnvironmentUAT         = "UAT"
tag_IT-Owner-Contact       = "admin@lab.com"
tag_Business-Owner-Contact = "admin@lab.com"
tag_Department             = "landingzone"
tag_Hours-Operational      = "24"
tag_Days-Operational       = "7"
tag_Billed-To              = "landingzone"
tag_Cost-Centre            = "landingzone"
tag_Terraform              = "Yes"

env = "test"
app1 = "myapp"

# Networking
# Virtual Networks

region1-spoke-vnets = {
  apptest = {
    name = "apptest"
    address_space = "10.96.108.0/22"
    routes = {
      default = {
        address_prefix = "0.0.0.0/0"
        next_hop_type = "VirtualAppliance"
      }
    }
  }
}

# vnetsdata = {
#   hub = {
#       name = "bw-vnet-uks-hub"
#       rg = "bw-rg-uks-connectivity"
#   }
#   identity = {
#       name = "bw-vnet-uks-identity"
#       rg = "bw-rg-uks-identity"
#   }
# }

# resourcegroupsdata = {
#   connectivity = {
#       name = "bw-rg-uks-connectivity"
#   }
#   dns = {
#       name = "bw-rg-uks-dns"
#   }
#   management = {
#       name = "bw-rg-uks-management"
#   }
# }

# logsdata = {
#   management = {
#       name = "bw-logs-uks-management-01"
#       rg = "bw-rg-uks-management"
#   }
# }



#subnets
region1-snets = {
  "apptest" = {
    "snet-app-test-resources-01" = {
      address_prefixes = ["10.96.108.64/27"]
      routetable = true
      default_outbound_access_enabled = false
      nsg_ruleset = {
      }
    }
    "snet-app-test-appgw-01" = {
      address_prefixes = ["10.96.108.128/27"]
      routetable = false
      default_outbound_access_enabled = false
      nsg_ruleset = {
        in-public-https = {
          name                       = "in-public-https"
          priority                   = 1100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "443"
          destination_port_ranges     = null
          source_address_prefix      = "Internet"
          destination_address_prefix = "*"
          description                = "in-https"
        }
        in-GatewayManager-monitoring = {
          name                       = "in-GatewayManager-monitoring"
          priority                   = 1200
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "65200-65535"
          destination_port_ranges     = null
          source_address_prefix      = "GatewayManager"
          destination_address_prefix = "*"
          description                = "in-GatewayManager-monitoring"
        }
      }
    }
    "snet-app-test-containerapps-01" = {
      address_prefixes = ["10.96.110.0/27"]
      routetable = true
      default_outbound_access_enabled = false
      nsg_ruleset = {}
      delegation = [
        {
          name = "Microsoft.App.environments"
          service_delegation = [
            {
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
              name    = "Microsoft.App/environments"
            }
          ]
        }
      ]
    }

  }
}

usegateway = true
gatewayip = "10.96.2.4"

#DNS
dns-servers = ["168.63.129.16"]
# dns-servers = []

privatednszones = {
  "privatelink.vaultcore.azure.net" = {}
  "privatelink.file.core.windows.net" = {}
  "privatelink.blob.core.windows.net" = {}
  "privatelink.azurecr.io" = {}
  "privatelink.azurewebsites.net" = {}
  # "azure-api.net" = {}
  "privatelink.database.windows.net" = {}
  "privatelink.postgres.database.azure.com" = {}
  "privatelink.redis.cache.windows.net" = {}
}

# dnszones_mgmt_enabled = true
# dnszones_identity_enabled = true

keyvault-access = {
  "test" = {
    # "admin-access" = {
    #   object_id = "ea54307d-2c04-4b64-b818-d6953e888c74"
    #   key_permissions = ["Get", "List", "UnwrapKey", "WrapKey", "Delete", "Purge", "Recover", "Restore", "Backup"]
    #   secret_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover", "Restore", "Backup"]
    #   certificate_permissions = ["Create","Delete","DeleteIssuers","Get","GetIssuers","Import","List","ListIssuers","ManageContacts","ManageIssuers","SetIssuers","Update","Purge",]
    #   storage_permissions = ["Get", "List", "Delete", "Set", "Purge"]
    # }
    "deployment" = {
      object_id = null
      key_permissions = ["Get", "List", "UnwrapKey", "WrapKey"]
      secret_permissions = ["Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set"]
      certificate_permissions = ["Create","Delete","DeleteIssuers","Get","GetIssuers","Import","List","ListIssuers","ManageContacts","ManageIssuers","SetIssuers","Update","Purge",]
      storage_permissions = ["Get", "List", "Delete", "Set", "Purge"]
    }
  }
}

cae = {
  cae01 = {
    name = "lab01"
    containers = {
      web = {
        name = "web"
        containers = {
          "container01" = {
            name = "container01"
            image  = "ghcr.io/tonytregcdw/docker-frontend-backend-db-lab/docker-lab-web:latest"
            cpu    = 0.75
            memory = "1.5Gi"
            env_vars = {}
            readiness_probe = {
                port = 3000
                transport = "TCP"
            }
          }
        }
        secrets = {
        }
        registries = {
        }
        ingress = {
          target_port = "3000"
          exposed_port = null
          transport = "http"
        }
      }
      api = {
        name = "api"
        containers = {
          "container01" = {
            name = "container01"
            image  = "ghcr.io/tonytregcdw/docker-frontend-backend-db-lab/docker-lab-api:latest"
            cpu    = 0.75
            memory = "1.5Gi"
            env_vars = {}
            readiness_probe = {
                port = 3001
                transport = "TCP"
            }
          }
        }
        secrets = {
        }
        registries = {
        }
        ingress = {
          target_port = "3001"
          exposed_port = "3001"
          transport = "tcp"
        }
      }
      db = {
        name = "db"
        containers = {
          "container01" = {
            name = "container01"
            image  = "ghcr.io/tonytregcdw/docker-frontend-backend-db-lab/docker-lab-mongo:latest"
            cpu    = 0.75
            memory = "1.5Gi"
            env_vars = {}
            readiness_probe = {
                port = 27017
                transport = "TCP"
            }
          }
        }
        secrets = {
        }
        registries = {
        }
        ingress = {
          target_port = "27017"
          exposed_port = "27017"
          transport = "tcp"
        }
      }
    }
  }
}



appgw = {
  test = {
    "name" = "app01"
    "protocol" = "Https"
    "port" = 443
    "sku" = "Basic_v2"
    "capacity" = 2
    "hostname" = "dev.appconnect.bestway.co.uk"
    "backend" = {
      app1 = {
        pool_members = [{ fqdn = "placeholder01" }]
        path        = "/"
        port        = 443
        protocol    = "Https"
        backend_setting_hostname = null
        listener_hostname = "app01.lab.co.uk"
      }
    }
  }
}

