/* Configure Azure Provider and declare all the Variables that will be used in Terraform configurations */
provider "azurerm" {
  version         = "~> 1.3"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# Remote tfstate File Reference
terraform {
  backend "azurerm" {
    storage_account_name = "tfstatefiles"
    container_name       = "tfstate"
    key                  = "synapsys-hosted.terraform.tfstate"
    access_key           = "${var.access_key}"
  }
}

variable "subscription_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "tenant_id" {}

variable "access_key" {}

variable "resource_name_prefix" {}

variable "resource_group_name" {}

variable "location" {}

variable "vm_username" {}

variable "vm_password" {}

variable "fw_avs_name" {}

variable "firewall_name" {}

variable "fw_username" {}

variable "fw_password" {}

variable "storage_acct_name" {}

variable "db_storage_acct_name" {}

variable "veritor_storage_acct_name" {}

variable "etl_storage_acct_name" {}

variable "etl_backup_storage_acct_name" {}

variable "etl_db_backup_storage_acct_name" {}

variable "vnet_name" {}

variable "address_space" {}

variable "mgmt_subnet" {}

variable "untrust_subnet" {}

variable "trust_subnet" {}

variable "syn_dmz_subnet" {}

variable "syn_data_subnet" {}

variable "ts_dmz_subnet" {}

variable "appgw_subnet" {}

variable "bdips" {}

variable "bdips1" {}

variable "bdips2" {}

variable "bdips3" {}

variable "dns_server" {}

variable "global_dns_server" {}

variable "appvm0_name" {}

variable "appvm1_name" {}

variable "app_server_avs_name" {}

variable "dbvm_name" {}

variable "db_server_avs_name" {}

variable "rdsvm_name" {}

variable "rds_server_avs_name" {}

variable "dcvm0_name" {}

variable "carrier_avs_name" {}

variable "carriervm0_name" {}

variable "ssis_avs_name" {}

variable "ssisvm0_name" {}

variable "sapds_avs_name" {}

variable "sapdsvm0_name" {}

variable "lb_name" {}

variable "appgw_name" {}

variable "rdp_nsg_name" {}

variable "app1_nsg_name" {}

variable "app2_nsg_name" {}

variable "db1_nsg_name" {}

variable "db2_nsg_name" {}

variable "servicebus_name" {}

variable "cis_sql_server_name" {}

variable "cis_sql_db_name" {}

variable "ds_sql_server_name" {}

variable "ds_sql_db_name" {}

variable "db_rson" {}

variable "db_collation" {}

variable "db_edition" {}

variable "ssl_data" {}

variable "ssl_password" {}

variable "auth_cert_data" {}

variable "join_domain_user" {
  description = "Enter HS domain user to join VMs to domain. Do not include HS prefix"
  default     = "user"
}

variable "join_domain_pass" {
  description = "Enter password of HS user to join VMs to domain"
  default     = "pass"
}
