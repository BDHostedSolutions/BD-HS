resource "azurerm_key_vault" "staging_key_vault" {
  name                = "TSFLVault-UK-QA-Secrets"
  location            = "ukwest"
  resource_group_name = "TS-UK-Staging"

  sku {
    name = "standard"
  }

  tenant_id = "94c3e67c-9e2d-4800-a6b7-635d97882165"

  access_policy {
    tenant_id = "94c3e67c-9e2d-4800-a6b7-635d97882165"
    object_id = "7198cc8d-2dc7-4ed8-baef-4ccbfc0bc227"

    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
    ]

    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers",
    ]
  }

  enabled_for_disk_encryption = false
}