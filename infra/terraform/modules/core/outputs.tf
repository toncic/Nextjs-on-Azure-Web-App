output "app_insights_connection_string" {
  value = azurerm_application_insights.app_insights.connection_string
}

output "keyvault_id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.kv.id
}
