/* Configure Azure Provider and declare all the Variables that will be used in Terraform configurations */
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "address_space" {}
variable "mgmt_subnet" {}
variable "untrust_subnet" {}
variable "trust_subnet" {}
variable "dmz_subnet" {}
variable "mm_subnet" {}
variable "hs_subnet" {}
variable "appgw_subnet" {}

variable "storage_acct_name" {}

variable "firewall_name" {}
variable "fw_username" {}

variable "fw_password" {
  description = "Enter Firewall Password"
}

variable "auth_cert_data" {}
variable "ssl_data" {}
variable "ssl_password" {}
