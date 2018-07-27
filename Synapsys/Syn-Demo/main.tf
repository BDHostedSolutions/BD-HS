#----root/main.tf

provider "azurerm" {
  version         = "~> 1.6"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

module "rg" {
  source = "./rg"
  resource_group_name = "${lookup(var.resource_group_name, var.env)}"
  location = "${lookup(var.location, var.env)}"
}

module "compute" {
  source         = "./compute"
  vm_username    = "${var.vm_username}"
  vm_password    = "${var.vm_password}"
  demovm_name    = "${lookup(var.demovm_name, var.env)}"
  domain_name    = "${lookup(var.domain_name, var.env)}"
  demovm_size    = "${var.demovm_size}"
  rg_name        = "${module.rg.resource_group_name}"
  rg_location    = "${module.rg.location}"
  demo_subnet    = "${module.networking.demo_subnet}"
}

module "networking" {
  source        = "./networking"
  rg_name       = "${module.rg.resource_group_name}"
  rg_location   = "${module.rg.location}"
  vnet_name     = "${lookup(var.vnet_name, var.env)}"
  address_space = "${var.address_space}"
  demo_subnet   = "${var.demo_subnet}"
  demo_nsg_name = "${var.demo_nsg_name}"
}