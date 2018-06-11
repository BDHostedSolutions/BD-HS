resource "azurerm_lb" "ts_prod_ilb" {
  name                = "${var.ts_prod_ilb_name}"
  location            = "${var.location}"
  sku                 = "Basic"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  frontend_ip_configuration {
    name                          = "LoadBalancerFrontend"
    private_ip_address            = "${cidrhost("${var.hosted_subnet}", 7)}"
    private_ip_address_allocation = "Static"
    subnet_id                     = "${azurerm_subnet.hosted_subnet.id}"
  }

  tags {
    display_name = "TS Services Load Balancer"
  }

  depends_on = ["azurerm_virtual_network.vnet"]
}

resource "azurerm_lb_backend_address_pool" "ts_prod_ilb_pool" {
  name                = "BackendPool1"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.ts_prod_ilb.id}"
}

resource "azurerm_lb_rule" "ts_prod_lbrule" {
  name                           = "lbrule"
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.ts_prod_ilb.id}"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontend"
  load_distribution              = "Default"
  enable_floating_ip             = false
  idle_timeout_in_minutes        = 15
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.ts_prod_ilb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.ts_prod_lbprobe.id}"
}

resource "azurerm_lb_rule" "ts_prod_lbrule2" {
  name                           = "lbrule2"
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.ts_prod_ilb.id}"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "LoadBalancerFrontend"
  load_distribution              = "Default"
  enable_floating_ip             = false
  idle_timeout_in_minutes        = 15
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.ts_prod_ilb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.ts_prod_lbprobe2.id}"
}

resource "azurerm_lb_probe" "ts_prod_lbprobe" {
  name                = "lbprobe"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.ts_prod_ilb.id}"
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 15
  number_of_probes    = 2
}

resource "azurerm_lb_probe" "ts_prod_lbprobe2" {
  name                = "lbprobe2"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.ts_prod_ilb.id}"
  protocol            = "Tcp"
  port                = 443
  interval_in_seconds = 15
  number_of_probes    = 2
}
