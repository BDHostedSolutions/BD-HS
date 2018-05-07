resource "azurerm_storage_account" "synapsysprd" {
  name                     = "${var.storage_acct_name}"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags {
    display_name = "Main Storage Account"
  }
}

resource "azurerm_storage_container" "vhds" {
  name                  = "vhds"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  storage_account_name  = "${var.storage_acct_name}"
  container_access_type = "private"

  depends_on = ["azurerm_storage_account.synapsysprd"]
}

resource "azurerm_storage_account" "synapsysdbprd" {
  name                     = "${var.db_storage_acct_name}"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags {
    display_name = "DB Backup Storage Account"
  }
}

resource "azurerm_storage_account" "veritorimagesprd" {
  name                     = "${var.veritor_storage_acct_name}"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_blob_encryption   = true
  enable_file_encryption   = true

  tags {
    display_name = "Storage Account for Veritor Images"
  }
}
