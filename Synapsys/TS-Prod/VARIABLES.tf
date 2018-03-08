/* Configure Azure Provider and declare all the Variables that will be used in Terraform configurations */
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
}

variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
}

variable "client_id" {
  description = "Enter Client ID"
}

variable "client_secret" {
  description = "Enter Client secret"
}

variable "tenant_id" {
  description = "Enter Tenant ID"
}

variable "resource_group_name" {
    description = ""
}

variable "location" {
    description = ""
}

variable "vm_username" {
  description = ""
}

variable "vm_password" {
  description = ""
}

variable "storage_acct_name" {
    description = ""
}

variable "db_storage_acct_name" {
    description = ""
}

variable "veritor_storage_acct_name" {
    description = ""
}

variable "vnet_name" {
    description = ""
}

variable "address_space" {
    description = ""
}

variable "subnet1_name" {
    description = ""
}

variable "subnet1_prefix" {
    description = ""
}

variable "subnet2_name" {
    description = ""
}

variable "subnet2_prefix" {
    description = ""
}

variable "dns_server" {
    description = ""
}

variable "global_dns_server" {
    description = ""
}

variable "appvm1_name" {
    description = ""
}

variable "ds_sql_db_name" {
    description = ""
}

variable "appvm2_name" {
    description = ""
}

variable "app_server_avs_name" {
    description = ""
}

variable "dbvm_name" {
    description = ""
}

variable "db_server_avs_name" {
    description = ""
}

variable "bdips" {
    description = ""
}

variable "bdips1" {
    description = ""
}

variable "bdips2" {
    description = ""
}

variable "bdips3" {
    description = ""
}

variable "lb_name" {
    description = ""
}

variable "rdp_nsg_name" {
    description = ""
}

variable "app1_nsg_name" {
    description = ""
}

variable "app2_nsg_name" {
    description = ""
}

variable "db1_nsg_name" {
    description = ""
}

variable "db2_nsg_name" {
    description = ""
}

variable "servicebus_name" {
    description = ""
}

variable "carriervm0_name" {
    description = ""
}

variable "carriervm1_name" {
    description = ""
}
variable "ssisvm0_name" {
    description = ""
}
variable "ssisvm1_name" {
    description = ""
}

variable "sapdsvm0_name" {
    description = ""
}
variable "shavlikvm0_name" {
    description = ""
}
variable "shavlikvm1_name" {
    description = ""
}
variable "dns_avs_name" {
    description = ""
}
variable "dnsvm1_name" {
    description = ""
}
variable "splunkvm_name" {
    description = ""
}
variable "calinux_name" {
    description = ""
}
variable "splunk_nsg_name" {
    description = ""
}
variable "carrier_avs_name" {
    description = ""
}
variable "sapdsvm1_name" {
    description = ""
}
variable "sapds_avs_name" {
    description = ""
}
variable "dnsvm0_name" {
    description = ""
}
variable "ext_ws_nsg_name" {
    description = ""
}
variable "ssis_avs_name" {
    description = ""
}
variable "cis_sql_server_name" {
    description = ""
}
variable "local_sql_rdp_nsg_name" {
    description = ""
}
variable "splunk_rdp_nsg_name" {
    description = ""
}
variable "ds_sql_server_name" {
    description = ""
}
variable "db_rson" {
    description = ""
}
variable "db_collation" {
    description = ""
}
variable "db_edition" {
    description = ""
}
variable "cis_sql_db_name" {
    description = ""
}
variable "sapds_ilb_name" {
    description = ""
}
variable "local_ws_rdp_nsg_name" {
    description = ""
}
variable "carrier_ilb_name" {
    description = ""
}
variable "etl_db_backup_storage_acct_name" {
    description = ""
}
variable "local_ws_nsg_name" {
    description = ""
}
variable "calinux_avs_name" {
    description = ""
}
variable "shavlik_avs_name" {
    description = ""
}
variable "prod_subnet_name" {
    description = ""
}
variable "prod_subnet_prefix" {
    description = ""
}
variable "splunk_avs_name" {
    description = ""
}
variable "local_sql_nsg_name" {
    description = ""
}
variable "etl_storage_acct_name" {
    description = ""
}
variable "etl_backup_storage_acct_name" {
    description = ""
}
variable "gw_subnet_name" {
    description = ""
}
variable "gw_subnet_prefix" {
    description = ""
}