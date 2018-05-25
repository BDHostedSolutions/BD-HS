#----storage/main.tf

resource "random_id" "tf_sa_id" {
  byte_length = 2
}
resource "azurerm_storage_account" "boot_diag" {
  name                     = "${var.storage_acct_name}-${random_id.tf_sa_id.dec}"
  resource_group_name      = "${var.rg_name}"
  location                 = "${var.rg_location}"
  account_kind             = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_file_encryption   = true
  enable_blob_encryption   = true

  tags {
    display_name = "Boot Diag Storage Account"
  }
}