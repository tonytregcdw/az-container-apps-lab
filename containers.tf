

# Container App environment
resource "azurerm_container_app_environment" "r1_containerappenv_01" {
    # name                = "${var.code}-cae-${var.region1code}-${var.app1}-${var.env}-01"
    name                = "${var.code}-cae-${var.region1code}-${var.cae["cae01"].name}-${var.env}-01"
    provider            = azurerm.app
    location            = azurerm_resource_group.r1_rg_app_appservices_01.location
    resource_group_name = azurerm_resource_group.r1_rg_app_appservices_01.name
    tags = {
        Environment            = var.env
        Application-Taxonomy   = "applications"
        IT-Owner-Contact       = var.tag_IT-Owner-Contact
        Business-Owner-Contact = var.tag_Business-Owner-Contact
        Department             = var.tag_Department
        Hours-Operational      = var.tag_Hours-Operational
        Days-Operational       = var.tag_Days-Operational
        Billed-To              = var.tag_Billed-To
        Cost-Centre            = var.tag_Cost-Centre
        Geography              = var.region1
        Terraform              = "Yes"
    }
    identity {
        type         = "SystemAssigned, UserAssigned"
        identity_ids = [azurerm_user_assigned_identity.userid_app_01.id]
    }
    log_analytics_workspace_id = azurerm_log_analytics_workspace.r1_logs_app_01.id

    workload_profile {
        name = "Consumption"
        workload_profile_type = "Consumption"
    }

    internal_load_balancer_enabled = true
    infrastructure_subnet_id = module.spokevnets_r1_app.subnetmap["snet-app-${var.env}-containerapps-01"].id
    zone_redundancy_enabled = try(var.cae["cae01"].zone_redundancy_enabled, false)
}


# #Local DNS private zone for app environment
# resource "azurerm_private_dns_zone" "r1_containerappenv_01_zone" {
#     provider            = azurerm.app
#     name                = azurerm_container_app_environment.r1_containerappenv_01.default_domain
#     resource_group_name = azurerm_resource_group.r1_rg_app_appservices_01.name
#     tags = {
#         Application-Taxonomy   = "DNS"
#         Environment            = var.env
#         Department             = var.tag_Department
#         Terraform              = "Yes"
#     }
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "r1_containerappenv_01_dnslink_app" {
#   name                = "dnslink-${module.spokevnets_r1_app.vnet.name}"
#   provider            = azurerm.app
#   resource_group_name = azurerm_resource_group.r1_rg_app_appservices_01.name
#   private_dns_zone_name = azurerm_private_dns_zone.r1_containerappenv_01_zone.name
#   virtual_network_id    = module.spokevnets_r1_app.vnet.id
#   tags = {
#     Environment            = var.env
#     Application-Taxonomy   = "DNS"
#     Department             = var.tag_Department
#     Terraform              = "Yes"
#   }
# }

#logging
resource "azurerm_monitor_diagnostic_setting" "cae_logs_01" {
  name               = "logs-${azurerm_container_app_environment.r1_containerappenv_01.name}"
  target_resource_id =  azurerm_container_app_environment.r1_containerappenv_01.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.r1_logs_app_01.id
  enabled_log {
    category_group = "allLogs"
  }
  enabled_metric {
    category = "AllMetrics"
  }
}

#container apps
resource "azurerm_container_app" "r1_containerapps_01" {
    for_each = var.cae["cae01"].containers
    name                = "${var.code}-ca-${var.region1code}-${var.cae["cae01"].name}-${each.value.name}-${var.env}"
    provider            = azurerm.app
    resource_group_name = azurerm_resource_group.r1_rg_app_appservices_01.name
    container_app_environment_id = azurerm_container_app_environment.r1_containerappenv_01.id
    workload_profile_name = "Consumption"
    revision_mode = "Single"
    identity {
        type         = "SystemAssigned, UserAssigned"
        identity_ids = [azurerm_user_assigned_identity.userid_app_01.id]
    }
    tags = {
        Environment            = var.env
        Application-Taxonomy   = "applications"
        IT-Owner-Contact       = var.tag_IT-Owner-Contact
        Business-Owner-Contact = var.tag_Business-Owner-Contact
        Department             = var.tag_Department
        Cost-Centre            = var.tag_Cost-Centre
        Terraform              = "Yes"
    }
    # lifecycle {
    #     ignore_changes = [
    #         secret,
    #         template,
    #         ingress,
    #         registry
    #     ]
    # }

    ingress {
        external_enabled = each.value.ingress.external_enabled
        traffic_weight {
            percentage = 100
            latest_revision = true
        }
        target_port =  each.value.ingress.target_port
        exposed_port = each.value.ingress.exposed_port
        transport = each.value.ingress.transport
    }
    dynamic "secret" {
        for_each = each.value.secrets
        content {
          name = lower(secret.key)
          identity = azurerm_user_assigned_identity.userid_app_01.id
          key_vault_secret_id = "https://${module.r1_keyvault_app_01.kv.name}.vault.azure.net/secrets/${secret.key}"
        }
    }
    dynamic "registry" {
        for_each = each.value.registries
        content {
            server = registry.value.server
            username = registry.value.username
            password_secret_name = registry.value.password_secret_name
        }
    }
    template {
        container { #make dynamic?
            name   = each.value.containers["container01"].name
            image  = each.value.containers["container01"].image
            cpu    = each.value.containers["container01"].cpu
            memory = each.value.containers["container01"].memory
            dynamic "env" {
                for_each = each.value.containers["container01"].env_vars
                content {
                    name  = env.key
                    value = env.value
                }
            }
            # dynamic "env" { # Secrets env variables
            #     for_each = each.value.containers["container01"].secrets
            #     content {
            #         name  = env.value
            #         secret_name = lower(env.key)
            #     }
            # }
            readiness_probe {
                port = each.value.containers["container01"].readiness_probe.port
                transport = each.value.containers["container01"].readiness_probe.transport
            }
        }
        max_replicas            = try(each.value.max_replicas, 1)
        min_replicas            = try(each.value.min_replicas, 1)
    }
}

# #DNS A record
# resource azurerm_private_dns_a_record "r1_containerapps_01_dns" {
#   for_each = var.cae["cae01"].containers
#   provider            = azurerm.app
#   name                = azurerm_container_app.r1_containerapps_01[each.key].name
#   zone_name           = azurerm_private_dns_zone.r1_containerappenv_01_zone.name
#   resource_group_name = azurerm_resource_group.r1_rg_app_appservices_01.name
#   ttl                 = "3600"
#   records             = [azurerm_container_app_environment.r1_containerappenv_01.static_ip_address]
# } 

