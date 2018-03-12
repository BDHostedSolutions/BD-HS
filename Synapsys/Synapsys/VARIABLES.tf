/* Configure Azure Provider and declare all the Variables that will be used in Terraform configurations */
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
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

variable "shared_resource_group_name" {
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
