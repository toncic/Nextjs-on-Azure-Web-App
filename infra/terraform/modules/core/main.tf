resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = "demo-nextjs-webapp-logs-${var.service_env}"
  resource_group_name = var.service_rg_name
  location            = var.service_location
}

resource "azurerm_application_insights" "app_insights" {
  name                = "demo-nextjs-webapp-${var.service_env}"
  location            = var.service_location
  resource_group_name = var.service_rg_name
  workspace_id        = azurerm_log_analytics_workspace.log_analytics_workspace.id
  application_type    = "other"

  lifecycle {
    ignore_changes = [tags]
  }
}
