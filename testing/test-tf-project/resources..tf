provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_public_ip" "ilb_pip" {
  name                         = "ILB-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    display_name = "Public IP"
  }
}

resource "azurerm_lb" "app_ilb" {
  name                = "${var.lb_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  tags {
    display_name = "LoadBalancer"
  }

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontend"
    public_ip_address_id = "${azurerm_public_ip.ilb_pip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "ilb_bep" {
  name                = "BackendPool1"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.app_ilb.id}"
}

resource "azurerm_lb_rule" "lbrule2" {
  name                           = "lbrule2"
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.app_ilb.id}"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "LoadBalancerFrontend"
  load_distribution              = "SourceIP"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.ilb_bep.id}"
  probe_id                       = "${azurerm_lb_probe.lbprobe2.id}"
}

resource "azurerm_lb_probe" "lbprobe2" {
  name                = "lbprobe2"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.app_ilb.id}"
  protocol            = "Tcp"
  port                = 443
  interval_in_seconds = 15
  number_of_probes    = 2
}

resource "azurerm_lb_nat_rule" "rdp0" {
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.app_ilb.id}"
  name                           = "rdp-0"
  protocol                       = "Tcp"
  frontend_port                  = 50001
  backend_port                   = 3389
  frontend_ip_configuration_name = "LoadBalancerFrontend"
  enable_floating_ip             = false
}

resource "azurerm_lb_nat_rule" "rdp1" {
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.app_ilb.id}"
  name                           = "rdp-1"
  protocol                       = "Tcp"
  frontend_port                  = 50002
  backend_port                   = 3389
  frontend_ip_configuration_name = "LoadBalancerFrontend"
  enable_floating_ip             = false
}

module "fw_infra" {
    source = "github.com/BDHostedSolutions/BD-HS//testing//tf-module"
    resource_group_name             = "${azurerm_resource_group.rg.name}"
    location                        = "${azurerm_resource_group.rg.location}"
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