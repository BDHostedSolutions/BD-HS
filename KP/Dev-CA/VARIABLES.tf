/* Configure Azure Provider and declare all the Variables that will be used in Terraform configurations */
provider "azurerm" {
  version         = "~> 1.11"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# Remote tfstate File Reference
terraform {
  backend "azurerm" {
    storage_account_name = "sacchskpvmprd01"
    container_name       = "tfstate"
    key                  = "kp-test-dev.terraform.tfstate"
    access_key           = "g6UqB+lWnmOF7bRl83fAeF7uHqLQYTil90puKIT4op/kHSgU3PH6g73fYD8KhgKeLA4P0MmYrRkLFJ/93ViTIA=="
  }
}

variable "subscription_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "tenant_id" {}

variable "location" {}

variable "resource_name_prefix" {}

variable "resource_group_name" {}

variable "address_space" {}

variable "dns_servers" {}

variable "global_dns_servers" {}

variable "mgmt_subnet" {}

variable "untrust_subnet" {}

variable "trust_subnet" {}

variable "dmz_subnet" {}

variable "appgw_subnet" {}

variable "firewall_name" {}

variable "kpfile01_name" {}

variable "kpapp01_name" {}

variable "kpidb01_name" {}

variable "kpidmcor01_name" {}

variable "kpmdb01_name" {}

variable "kprds01_name" {}

variable "kpdc01_name" {}

variable "kprpt01_name" {}

variable "kpweb01_name" {}

variable "kpweb02_name" {}

variable "fw_username" {}

variable "fw_password" {}

variable "ILB_name" {}

variable "AppGw_name" {}

variable "ssl_data" {}

variable "ssl_password" {}

variable "auth_cert_data" {}

variable "vm_username" {}

variable "vm_password" {}

variable "firewall_size" {}

variable "kpfile01_size" {}

variable "kpapp01_size" {}

variable "kpidb01_size" {}

variable "kpmdb01_size" {}

variable "kprds01_size" {}

variable "kpdc01_size" {}

variable "kprpt01_size" {}

variable "kpweb_size" {}

variable "kpidmcor01_size" {}
