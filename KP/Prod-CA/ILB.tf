resource "azurerm_lb" "ILB_DMZ" {
  name                = "${var.resource_name_prefix}-${var.ILB_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  frontend_ip_configuration {
    name                          = "LoadBalancerFrontend"
    subnet_id                     = "${azurerm_subnet.dmz_subnet.id}"
    private_ip_address            = "${cidrhost("${var.dmz_subnet}", 6)}"
    private_ip_address_allocation = "static"
  }
}

resource "azurerm_lb_backend_address_pool" "Web_Pool" {
  name                = "KPWeb-Pool"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.ILB_DMZ.id}"
}

resource "azurerm_lb_rule" "HTTP_LBRule" {
  name                           = "HTTP-LBRule"
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.ILB_DMZ.id}"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontend"
  load_distribution              = "SourceIP"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.Web_Pool.id}"
  probe_id                       = "${azurerm_lb_probe.HTTP_Probe.id}"
}

resource "azurerm_lb_rule" "HTTPS_LBRule" {
  name                           = "HTTPS-LBRule"
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.ILB_DMZ.id}"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "LoadBalancerFrontend"
  load_distribution              = "SourceIP"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.Web_Pool.id}"
  probe_id                       = "${azurerm_lb_probe.HTTPS_Probe.id}"
}

resource "azurerm_lb_probe" "HTTP_Probe" {
  name                = "HTTP-Probe"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.ILB_DMZ.id}"
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
}

resource "azurerm_lb_probe" "HTTPS_Probe" {
  name                = "HTTPS-Probe"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.ILB_DMZ.id}"
  protocol            = "Tcp"
  port                = 443
  interval_in_seconds = 5
}
