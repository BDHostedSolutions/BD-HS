/* Configure Azure Provider and declare all the Variables that will be used in Terraform configurations */
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {}

variable "resource_group_name" {}

variable "vnet_name" {}
variable "address_space" {}
variable "prod_subnet_name" {}
variable "prod_subnet_prefix" {}
variable "gw_subnet_name" {}
variable "gw_subnet_prefix" {}

variable "dns_server" {}
variable "global_dns_server" {}

variable "bdips" {}
variable "bdips1" {}
variable "bdips2" {}
variable "bdips3" {}

variable "storage_acct_name" {}
variable "etl_storage_acct_name" {}
variable "etl_backup_storage_acct_name" {}
variable "etl_db_backup_storage_acct_name" {}

variable "vm_username" {}
variable "vm_password" {}

variable "app_server_avs_name" {}
variable "appvm1_name" {}
variable "app1_nsg_name" {}
variable "appvm2_name" {}
variable "app2_nsg_name" {}

variable "db_server_avs_name" {}
variable "dbvm_name" {}
variable "db1_nsg_name" {}
variable "db2_nsg_name" {}

variable "carrier_avs_name" {}
variable "carrier_ilb_name" {}
variable "carriervm0_name" {}
variable "carriervm1_name" {}

variable "ssis_avs_name" {}
variable "ssisvm0_name" {}
variable "ssisvm1_name" {}

variable "sapds_avs_name" {}
variable "sapds_ilb_name" {}
variable "sapdsvm0_name" {}
variable "sapdsvm1_name" {}

variable "shavlik_avs_name" {}
variable "shavlikvm0_name" {}
variable "shavlikvm1_name" {}

variable "dns_avs_name" {}
variable "dnsvm0_name" {}
variable "dnsvm1_name" {}

variable "splunk_avs_name" {}
variable "splunkvm_name" {}

variable "calinux_avs_name" {}
variable "calinux_name" {}

variable "rdp_nsg_name" {}
variable "ext_ws_nsg_name" {}
variable "splunk_rdp_nsg_name" {}
variable "splunk_nsg_name" {}
variable "local_sql_rdp_nsg_name" {}
variable "local_sql_nsg_name" {}
variable "local_ws_rdp_nsg_name" {}
variable "local_ws_nsg_name" {}

variable "cis_sql_server_name" {}
variable "cis_sql_db_name" {}
variable "ds_sql_server_name" {}
variable "ds_sql_db_name" {}
variable "db_rson" {}
variable "db_collation" {}
variable "db_edition" {}

variable "servicebus_name" {}