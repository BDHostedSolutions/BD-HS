resource "azurerm_lb" "app_ilb" {
  name                = "${var.resource_name_prefix}-${var.lb_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  tags {
    display_name = "Internal Load Balancer"
  }

  frontend_ip_configuration {
    name                          = "LoadBalancerFrontend"
    subnet_id                     = "${azurerm_subnet.dmz_subnet.id}"
    private_ip_address            = "${cidrhost("${var.dmz_subnet}", 6)}"
    private_ip_address_allocation = "static"
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