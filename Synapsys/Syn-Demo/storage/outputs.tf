#----storage/outputs.tf

output "storage_acct_name" {
    value = "${azurerm_storage_account.boot_diag.primary_blob_endpoint}"
}