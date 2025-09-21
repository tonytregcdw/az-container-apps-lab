
#public ips
resource "azurerm_public_ip" "appgw-pip-01" {
  name                = "${var.code}-pip-${var.regioncode}-${var.app-gateway.name}"
  location            = var.region
  provider            = azurerm
  resource_group_name = var.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [ 1, 2, 3 ] 
  tags = {
    Application-Taxonomy   = "Security"
    Geography              = var.region
    Department             = var.tag_Department
    Environment            = var.tag_Environment
    Terraform              = "Yes"
  }
}

resource "azurerm_web_application_firewall_policy" "appgw_waf_policy" {
  name                = "${var.code}-wafpol-${var.regioncode}-${var.app-gateway.name}"
  resource_group_name = var.rg.name
  location            = var.region

  dynamic "custom_rules" {
    for_each = var.waf_custom_rules != null ? var.waf_custom_rules : []
    content {
      name      = custom_rules.value.name
      priority  = custom_rules.value.priority
      rule_type = custom_rules.value.rule_type
      match_conditions {
        operator           = custom_rules.value.match_conditions.operator
        negation_condition = custom_rules.value.match_conditions.negation_condition
        match_values       = custom_rules.value.match_conditions.match_values

        dynamic "match_variables" {
          for_each = custom_rules.value.match_conditions.match_variables
          content {
            variable_name = match_variables.value.variable_name
            selector      = lookup(match_variables.value, "selector", null)
          }
        }
      }
      action = custom_rules.value.action
    }
  }

  policy_settings {
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
    request_body_check          = true
    mode                        = "Detection"
    request_body_enforcement    = true
    request_body_inspect_limit_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
    managed_rule_set {
      type    = "Microsoft_BotManagerRuleSet"
      version = "1.1"
    }
  }

  tags = {
    Application-Taxonomy   = "Security"
    Geography              = var.region
    Department             = var.tag_Department
    environment            = var.tag_Environment
    Terraform              = "Yes"
  }
}


#app gateway
resource "azurerm_application_gateway" "appgw" {
  name                = "${var.code}-appgw-${var.regioncode}-${var.app-gateway.name}"
  resource_group_name = var.rg.name
  location            = var.rg.location
  provider            = azurerm
  zones               = [1, 2, 3]
  lifecycle {
  ignore_changes = [
    ssl_certificate,
    http_listener,
    ]
  }
  tags = {
    Environment            = var.tag_Environment
    Application-Taxonomy   = "applications"
    Department             = var.tag_Department
    Geography              = var.region
    Terraform              = "Yes"
  }
  sku {
    name     = var.app-gateway.sku
    tier     = var.app-gateway.sku
    # capacity = var.app-gateway.capacity
  }
  autoscale_configuration {
    max_capacity = var.app-gateway.capacity
    min_capacity = 1
  }
  dynamic "trusted_root_certificate" {
    for_each = try(var.app-gateway.backend.backend_cert, null) != null ? [var.app-gateway.backend.backend_cert] : []
    content {
      name = "backend-root-ca"
      data = filebase64(trusted_root_certificate.value)
    }
  }
  
  firewall_policy_id = var.app-gateway.sku == "WAF_v2" ? azurerm_web_application_firewall_policy.appgw_waf_policy.id : null


  gateway_ip_configuration {
    name      = "ipconfig-01"
    subnet_id = var.subnet.id
  }

  ssl_certificate {
    name     = "cert-01"
    key_vault_secret_id = var.sslcert.versionless_secret_id
  }

  frontend_port {
    name = "fe-port-01"
    port = var.app-gateway.port
  }

  frontend_ip_configuration {
    name                 = "feip-pub-01"
    public_ip_address_id = azurerm_public_ip.appgw-pip-01.id
  }

  # frontend_ip_configuration {
  #   name                 = "${var.code}-appgw-privip-${var.regioncode}"
  #   private_ip_address_allocation = "Static"
  #  private_ip_address   = var.app-gateway.ip
  #   subnet_id = var.subnet.id
  # }

  identity {
    type = "UserAssigned"
    identity_ids = [var.certidentity]
  }

  dynamic "backend_address_pool" {
    for_each = var.app-gateway.backend
    content {
      name  = "pool-${backend_address_pool.key}"
      fqdns = [for member in backend_address_pool.value.pool_members : member.fqdn]
    }
  }

  dynamic "probe" {
    for_each = var.app-gateway.backend
    content {
      name     = "probe-${probe.key}"
      protocol = probe.value.protocol
      path     = probe.value.path
      interval = 30
      timeout  = 30
      unhealthy_threshold = 3
      pick_host_name_from_backend_http_settings = true
      match {
        status_code = ["200-399"]
      }
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.app-gateway.backend
    content {
      name                  = "backend-${backend_http_settings.key}"
      cookie_based_affinity = "Disabled"
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = 60
      pick_host_name_from_backend_address = try(backend_http_settings.value.backend_settings_hostname, null) == null ? true : false
      host_name = try(backend_http_settings.value.backend_settings_hostname, null)
      trusted_root_certificate_names = try(backend_http_settings.value.backend_cert,null) != null ? ["backend-root-ca"] : []
      probe_name = "probe-${backend_http_settings.key}"
    }
  }

  dynamic "http_listener" {
    for_each = var.app-gateway.backend
    content {
      #fix to include multisite
      name                           = "http-listener-${http_listener.key}"
      frontend_ip_configuration_name = "feip-pub-01"
      frontend_port_name             = "fe-port-01"
      protocol                       = http_listener.value.protocol
      require_sni                    = try(http_listener.value.listener_hostname, null) == null ? false : true
      ssl_certificate_name           = "cert-01"
      host_name                      = try(http_listener.value.listener_hostname, null) == null ? null : http_listener.value.listener_hostname
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.app-gateway.backend
    content {
      name                       = "request-rule-${request_routing_rule.key}"
      rule_type                  = "Basic"
      http_listener_name         = "http-listener-${request_routing_rule.key}"
      backend_address_pool_name  = "pool-${request_routing_rule.key}"
      backend_http_settings_name = "backend-${request_routing_rule.key}"
      priority                   = 100 + index(keys(var.app-gateway.backend), request_routing_rule.key)
    }
  }
}

#add logging if provided
resource "azurerm_monitor_diagnostic_setting" "logs" {
  count        = var.logging == null ? 0 : 1 
  name               = "logs-${azurerm_application_gateway.appgw.name}"
  target_resource_id =  azurerm_application_gateway.appgw.id
  log_analytics_workspace_id = var.logging.id
  enabled_log {
    category_group = "allLogs"
  }
}
