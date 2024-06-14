
data "azurerm_resource_group" "rg" {
  name = var.service_rg_name
}

data "azurerm_client_config" "current" {}

resource "azurerm_linux_web_app" "appservice" {
  name                = "demo-nextjs-webapp-appsvc-${var.service_env}-${var.service_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  service_plan_id     = var.service_plan_id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }
  site_config {

    app_command_line = "yarn run start:azure"
    http2_enabled    = true
    application_stack {
      node_version = "18-lts"
    }
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 30
        retention_in_mb   = 35
      }
    }
  }

  app_settings = var.service_app_config
}

resource "azurerm_key_vault_access_policy" "kvaccess" {
  key_vault_id = var.kv_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.appservice.identity.0.principal_id

  secret_permissions = [
    "Get", "List",
  ]
}
