data "azurerm_resource_group" "rg" {
  name = var.service_rg_name
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "demo-nextjs-webapp-sp-${var.service_env}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"

  lifecycle {
    ignore_changes = [tags]
  }
}
