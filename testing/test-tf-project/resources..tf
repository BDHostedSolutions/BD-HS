provider "azurerm" {
  version         = "~> 1.3"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}


# Remote tfstate File Reference
terraform {
  backend "azurerm"  {
    storage_account_name = "tfstatefiles"
    container_name       = "tfstate"
    key                  = "module.terraform.tfstate"
  }
}



module "fw_infra" {
    source = "github.com/BDHostedSolutions/BD-HS//testing//tf-module"
    resource_group_name             = "${var.resource_group_name}"
    location                        = "${var.location}"
    vnet_name                       = "${var.vnet_name}"
    address_space                   = "${var.address_space}"
    mgmt_subnet                     = "${var.mgmt_subnet}"
    untrust_subnet                  = "${var.untrust_subnet}"
    trust_subnet                    = "${var.trust_subnet}"
    dns_server                      = "${var.dns_server}"
    global_dns_server               = "${var.global_dns_server}"
    storage_acct_name               = "${var.storage_acct_name}"
    fwavs_name                      = "${var.fwavs_name}"
    firewall_name                   = "${var.firewall_name}"
    fw_username                     = "${var.fw_username}"
    fw_password                     = "${var.fw_password}"
}

module "ilb" {
    source = "github.com/BDHostedSolutions/BD-HS//testing//tf-module"
    ilb_name                        = "${var.ilb_name}"
}