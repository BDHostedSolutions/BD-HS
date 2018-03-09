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

variable "address_space" {
  description = "The address space that is used by the virtual network."
}

variable "mgmt_subnet" {
  description = "The address prefix to use for the MGMT subnet."
}

variable "untrust_subnet" {
  description = "The address prefix to use for the UNTRUST subnet."
}

variable "trust_subnet" {
  description = "The address prefix to use for the TRUST subnet."
}

variable "dmz_subnet" {
  description = "The address prefix to use for the DMZ subnet."
}

variable "appgw_subnet" {
  description = "The address prefix to use for the AppGw subnet."
}

variable "firewall_name" {}
variable "fw_username" {}

variable "fw_password" {
  description = "Enter Firewall Password"
}
