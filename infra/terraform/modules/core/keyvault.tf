resource "azurerm_key_vault" "kv" {
  name                          = "demo-nextjs-webapp-kvault-${var.service_env}"
  location                      = var.service_location
  resource_group_name           = var.service_rg_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption   = true
  public_network_access_enabled = true
  soft_delete_retention_days    = 60
  purge_protection_enabled      = true

  sku_name = "standard"
  lifecycle {
    ignore_changes = [tags]
  }
}

data "azurerm_client_config" "current" {}

#This is access for SP that is used by Azure DevOps to get secrets from the key vault.
resource "azurerm_key_vault_access_policy" "sp_kvaccess" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  secret_permissions = [
    "Get", "List"
  ]
}

# Below access policies are used to allow access to the key vault for users to create secrets. 
# All users should be added here, and are created for all environments. 
# In case if we don't want to give an access in some enviroment we should rewrite this part, and move access to the environment specific part.
resource "azurerm_key_vault_access_policy" "mt_kvaccess" {
  # Milan
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "e1803b31-bac4-4c00-855d-a551999c1626"
  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Purge", "Backup", "Restore"
  ]
}