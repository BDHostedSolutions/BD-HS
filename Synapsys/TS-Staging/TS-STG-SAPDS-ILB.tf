resource "azurerm_lb" "sapds_ilb" {
  name                = "${var.sapds_ilb_name}"
  location            = "${var.location}"
  sku                 = "Basic"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  frontend_ip_configuration {
    name                          = "LoadBalancerFrontend"
    private_ip_address            = "${cidrhost("${var.stg_subnet_prefix}", 12)}"
    private_ip_address_allocation = "Static"
    subnet_id                     = "${azurerm_subnet.stg_subnet.id}"
  }

  tags {
    display_name = "DS App Load Balancer"
  }

  depends_on = ["azurerm_virtual_network.vnet"]
}

resource "azurerm_lb_backend_address_pool" "sapds_ilb_pool" {
  name                = "BackendPool1"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.sapds_ilb.id}"
}

resource "azurerm_lb_rule" "sapds_lbrule" {
  name                           = "lbrule"
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.sapds_ilb.id}"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontend"
  load_distribution              = "Default"
  enable_floating_ip             = false
  idle_timeout_in_minutes        = 15
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.sapds_ilb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.sapds_lbprobe.id}"
}

resource "azurerm_lb_rule" "sapds_lbrule2" {
  name                           = "lbrule2"
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.sapds_ilb.id}"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "LoadBalancerFrontend"
  load_distribution              = "Default"
  enable_floating_ip             = false
  idle_timeout_in_minutes        = 15
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.sapds_ilb_pool.id}"
  probe_id                       = "${azurerm_lb_probe.sapds_lbprobe2.id}"
}

resource "azurerm_lb_probe" "sapds_lbprobe" {
  name                = "lbprobe"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.sapds_ilb.id}"
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 15
  number_of_probes    = 2
}

resource "azurerm_lb_probe" "sapds_lbprobe2" {
  name                = "lbprobe2"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.sapds_ilb.id}"
  protocol            = "Tcp"
  port                = 443
  interval_in_seconds = 15
  number_of_probes    = 2
}
