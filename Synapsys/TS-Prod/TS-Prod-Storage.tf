resource "azurerm_storage_account" "etl_storage_acct" {
  name                      = "${var.etl_storage_acct_name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${var.location}"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = false
  enable_file_encryption    = true
  enable_blob_encryption    = true
  account_encryption_source = "Microsoft.Storage"

  tags {
    display_name            = "SAP File Drop"
  }
}

resource "azurerm_storage_account" "etl_db_backup_storage_acct" {
  name                      = "${var.etl_db_backup_storage_acct_name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${var.location}"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = false
  enable_file_encryption    = true
  enable_blob_encryption    = true
  account_encryption_source = "Microsoft.Storage"

  tags {
    display_name            = "SSIS DB Backup"
  }
}

resource "azurerm_storage_account" "etl_backup_storage_acct" {
  name                      = "${var.etl_backup_storage_acct_name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${var.location}"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = false
  enable_file_encryption    = true
  enable_blob_encryption    = true
  account_encryption_source = "Microsoft.Storage"

  tags {
    display_name            = "SAP File Backup"
  }
}

resource "azurerm_storage_account" "storage_acct" {
  name                      = "${var.storage_acct_name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  location                  = "${var.location}"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = false
  
  tags {
    display_name            = "VHD Storage Account"
  }
}

resource "azurerm_storage_container" "vhds" {
  name                      = "vhds"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  storage_account_name      = "${var.storage_acct_name}"
  container_access_type     = "private"

  depends_on                = ["azurerm_storage_account.storage_acct"]
}