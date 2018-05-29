#----root/main.tf

provider "azurerm" {
  version         = "~> 1.6"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

terraform {
  backend "azurerm" {
    storage_account_name = "tfstatefiles"
    container_name       = "tfstate"
    key                  = "syn-demo.terraform.tfstate"
    access_key           = "nWj7Yk9yZKXGYj9TPRrRB/MuQhlOX9a3xwwvY2Vqq8pFUs+0zJEu2TU2aN/+8hvLs0Ojk/SLKPpPBPKbgaf2aA=="
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${lookup(var.resource_group_name, var.env)}"
  location = "${lookup(var.location, var.env)}"
}


module "storage" {
  source               = "./storage"
  storage_acct_name    = "${lookup(var.storage_acct_name, var.env)}"
  rg_name              = "${lookup(var.resource_group_name, var.env)}"
  rg_location          = "${lookup(var.location, var.env)}"
}

module "compute" {
  source         = "./compute"
  vm_username    = "${var.vm_username}"
  vm_password    = "${var.vm_password}"
  demovm_name    = "${lookup(var.demovm_name, var.env)}"
  demovm_size    = "${var.demovm_size}"
  rg_name        = "${lookup(var.resource_group_name, var.env)}"
  rg_location    = "${lookup(var.location, var.env)}"
  boot_diag      = "${module.storage.storage_acct_name}"
  demo_subnet    = "${module.networking.demo_subnet}"
}

module "networking" {
  source        = "./networking"
  rg_name       = "${lookup(var.resource_group_name, var.env)}"
  rg_location   = "${lookup(var.location, var.env)}"
  vnet_name     = "${lookup(var.vnet_name, var.env)}"
  address_space = "${var.address_space}"
  demo_subnet   = "${var.demo_subnet}"
  demo_nsg_name = "${var.demo_nsg_name}"
}