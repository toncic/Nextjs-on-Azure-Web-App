locals {
  app_settings_global = {
    WEBSITE_RUN_FROM_PACKAGE              = 1
    APPLICATIONINSIGHTS_CONNECTION_STRING = module.core.app_insights_connection_string
  }
  kv_uri = "https://demo-nextjs-webapp-kvault-${var.service_env}.vault.azure.net"
}

module "core" {
  source = "../../modules/core"

  service_env      = var.service_env
  service_location = var.service_location
  service_rg_name  = var.service_rg_name
}

module "service_plan" {
  source = "../../modules/serviceplan"

  service_env     = var.service_env
  service_rg_name = var.service_rg_name
}

module "app_service_global" {
  source = "../../modules/webappservice"

  service_name     = "global"
  service_env      = var.service_env
  service_location = var.service_location
  service_rg_name  = var.service_rg_name
  service_plan_id  = module.service_plan.app_service_plan_id
  kv_id            = module.core.keyvault_id
  service_app_config = merge(local.app_settings_global, {
    // SECRETS
    # EXAMPLE_SECRET = "@Microsoft.KeyVault(SecretUri=${local.kv_uri}/secrets/ExampleSecret/)"
  })
}
