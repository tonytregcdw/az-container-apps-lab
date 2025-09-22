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
    # "bw-mg-nonprod-wholesale-contributor" = {
    #   object_id = "a1be5851-1c70-4482-acd8-665885e531d8"
    #   key_permissions = ["Get", "List", "UnwrapKey", "WrapKey"]
    #   secret_permissions = ["Get", "List", "Set"]
    #   certificate_permissions = ["Create","Delete","DeleteIssuers","Get","GetIssuers","Import","List","ListIssuers","ManageContacts","ManageIssuers","SetIssuers","Update","Purge",]
    #   storage_permissions = ["Get", "List"]
    # }
    # "admin-access" = {
    #   object_id = "ea54307d-2c04-4b64-b818-d6953e888c74"
    #   key_permissions = ["Get", "List", "UnwrapKey", "WrapKey", "Delete", "Purge", "Recover", "Restore", "Backup"]
    #   secret_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover", "Restore", "Backup"]
    #   certificate_permissions = ["Create","Delete","DeleteIssuers","Get","GetIssuers","Import","List","ListIssuers","ManageContacts","ManageIssuers","SetIssuers","Update","Purge",]
    #   storage_permissions = ["Get", "List", "Delete", "Set", "Purge"]
    # }
    # "az-software-developers" = {
    #   object_id = "09dc2fcc-59a1-4873-b206-94f5bb69dddb"
    #   key_permissions = []
    #   secret_permissions = ["Get", "List", "Set"]
    #   certificate_permissions = []
    #   storage_permissions = []
    # }
    # "AZ - Solutions Architects" = {
    #   object_id = "0031c92e-0a98-41ba-a366-e62b13c97721"
    #   key_permissions = []
    #   secret_permissions = ["Get", "List", "Set"]
    #   certificate_permissions = []
    #   storage_permissions = []
    # }
    # "bw-mg-prod-wholesale-contributor" = {
    #   object_id = "e2cace89-ce3a-489e-aa66-c6643c2a7b30"
    #   key_permissions = ["Get", "List", "UnwrapKey", "WrapKey"]
    #   secret_permissions = ["Get", "List", "Set"]
    #   certificate_permissions = ["Create","Delete","DeleteIssuers","Get","GetIssuers","Import","List","ListIssuers","ManageContacts","ManageIssuers","SetIssuers","Update","Purge",]
    #   storage_permissions = ["Get", "List"]
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
    name = "epos"
    containers = {
      app01 = {
        name = "api"
        containers = {
          container01 = {
            name = "epos-api"
            image  = "ghcr.io/bestway-csg/epos-api:17"
            cpu    = 0.75
            memory = "1.5Gi"
            env_vars = {
              ABI_SFTP_HOST           = "10.197.75.33"
              ABI_SFTP_ORDERS_PATH    = "/Export Files/Delivered_Test/Orders/API/"
              ABI_SFTP_PORT           = "22"
              EPOS_API_AUTH_URL       = "https://authbridgeapi.stage.costcutter.com"
              EPOS_API_SERVICE_HOST   = "10.197.75.39"
              EPOS_API_SERVICE_PORT   = "6001"
              EPOS_DB_URL             = "jdbc:sqlserver://bwsqlukspos-test.database.windows.net:1433;database=bwsqldbuksapptest01;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
              EPOS_DB_USER            = "eposdev"
            }
            readiness_probe = {
              port = 8080
              transport = "TCP"
            }
          }
        }
        secrets = {
          # KV-SECRET-REFERENCE = ENV_VARIABLE_NAME
          ABI-SFTP-USER             = "ABI_SFTP_USER"
          # AZURE-STORAGE-CONNECTION  = "AZURE_STORAGE_CONNECTION"
          ABI-SFTP-PASSWORD         = "ABI_SFTP_PASSWORD"
          CONTAINER-TOKEN           = "CONTAINER_TOKEN"
        }
        registries = { # change this - not doing anything at present.
          "ghcr.io" = {
            server = "ghcr.io"
            username = "tonytregcdw"
            password_secret_name = "container-token"
          }
        }
        ingress = {
          target_port = "8080"
          exposed_port = null
          transport = "http"
        }
      }
      app02 = {
        name = "data"
        containers = {
          container01 = {
            name = "epos-data-producer"
            image  = "ghcr.io/bestway-csg/epos-data-producer:3"
            cpu    = 0.75
            memory = "1.5Gi"
            env_vars = {
            }
            readiness_probe = {
              port = 8080
              transport = "TCP"
            }
          }
        }
        registries = { # change this - not doing anything at present.
          "ghcr.io" = {
            server = "ghcr.io"
            username = "tonytregcdw"
            password_secret_name = "container-token"
          }
        }
        ingress = {
          target_port = "8080"
          exposed_port = "8080"
          transport = "tcp"
        }
        secrets = {
          # AZURE-STORAGE-CONNECTION  = "AZURE_STORAGE_CONNECTION"
          CONTAINER-TOKEN           = "CONTAINER_TOKEN"
        }
      }
    }
  }
  cae02 = {
    name = "dts"
    containers = {
      app01 = {
        name = "app01"
        containers = {
          "container01" = {
            name = "container01"
            image  = "nginx:latest"
            cpu    = 0.75
            memory = "1.5Gi"
            env_vars = {}
            readiness_probe = {
                port = 80
                transport = "TCP"
            }
          }
        }
        secrets = {
        }
        registries = {
        }
        ingress = {
          target_port = "80"
          exposed_port = null
          transport = "http"
        }
      }
      app02 = {
        name = "app02"
        containers = {
          "container01" = {
            name = "container01"
            image  = "nginx:latest"
            cpu    = 0.75
            memory = "1.5Gi"
            env_vars = {}
            readiness_probe = {
                port = 80
                transport = "TCP"
            }
          }
        }
        secrets = {
        }
        registries = {
        }
        ingress = {
          target_port = "80"
          exposed_port = "81"
          transport = "tcp"
        }
      }
      app03 = {
        name = "app03"
        containers = {
          "container01" = {
            name = "container01"
            image  = "nginx:latest"
            cpu    = 0.75
            memory = "1.5Gi"
            env_vars = {}
            readiness_probe = {
                port = 80
                transport = "TCP"
            }
          }
        }
        secrets = {
        }
        registries = {
        }
        ingress = {
          target_port = "80"
          exposed_port = "82"
          transport = "tcp"
        }
      }
      app04 = {
        name = "app04"
        containers = {
          "container01" = {
            name = "container01"
            image  = "nginx:latest"
            cpu    = 0.75
            memory = "1.5Gi"
            env_vars = {}
            readiness_probe = {
                port = 80
                transport = "TCP"
            }
          }
        }
        secrets = {
        }
        registries = {
        }
        # registries = {
        #   "ghcr.io" = {
        #     server = "ghcr.io"
        #     username = "ghcr-user"
        #     password = "secret"
        #   }
        # }
        ingress = {
          target_port = "80"
          exposed_port = "83"
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
    "sku" = "WAF_v2"
    "capacity" = 2
    "hostname" = "dev.appconnect.bestway.co.uk"
    "backend" = {
      app1 = {
        pool_members = [{ fqdn = "bw-app-uks-frontend-test-01.azurewebsites.net" }]
        path        = "/actuator/health"
        port        = 443
        protocol    = "Https"
        backend_setting_hostname = null
        listener_hostname = "dev.appconnect.bestway.co.uk"
      }
      # app2 = {
      #   pool_members = [{ fqdn = "${azurerm_api_management_api.r1_apim_api_01.api_management_name}.azure-api.net" }]
      #   path        = "/apitest01/actuator/health"
      #   port        = 443
      #   protocol    = "Https"
      #   backend_setting_hostname = null
      #   listener_hostname = "devapi.appconnect.bestway.co.uk"
      # }
      app3 = {
        pool_members = [{ 
          fqdn = "bw-ca-uks-dts-app01-test.ashypond-56daabcb.uksouth.azurecontainerapps.io"
        }]
        path        = "/"
        port        = 443
        protocol    = "Https"
        backend_setting_hostname = null
        listener_hostname = "dts.bestway.co.uk"
      }
    }
  }
}

