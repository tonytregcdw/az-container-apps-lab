
#Create self signed cert for app services
resource "azurerm_key_vault_certificate" "appgw_01_cert" {
  name         = "appgateway-cert"
  provider = azurerm.app
  key_vault_id = module.r1_keyvault_app_01.kv.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["dev.appconnect.bestway.co.uk", "uat.appconnect.bestway.co.uk"]
      }

      subject            = "CN=appgatway"
      validity_in_months = 12
    }
  }
}

module "r1_appgw_01" {
  source = "./appgateway"
  providers = {
    azurerm = azurerm.app
  }
  for_each = var.appgw
  subnet = module.spokevnets_r1_app.subnetmap["snet-app-${var.env}-appgw-01"]
  rg = azurerm_resource_group.r1_rg_app_01
  region = var.region1
  regioncode = var.region1code
  code = var.code
  tag_Department = var.tag_Department
  logging = azurerm_log_analytics_workspace.r1_logs_app_01
  tag_Environment = var.env

  waf_custom_rules = []
  app-gateway = each.value

  sslcert = azurerm_key_vault_certificate.appgw_01_cert
  certidentity = azurerm_user_assigned_identity.userid_app_01.id
}
