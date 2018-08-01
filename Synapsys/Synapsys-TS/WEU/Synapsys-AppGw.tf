resource "azurerm_public_ip" "AppGw_pip" {
  name                         = "AppGw-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"
}

resource "azurerm_application_gateway" "App_Gw" {
  name                = "${var.resource_name_prefix}-${var.appgw_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  sku {
    name     = "Standard_Medium"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = "${azurerm_subnet.appgw_subnet.id}"
  }

  frontend_port {
    name = "HTTP"
    port = 80
  }
  frontend_port {
    name = "HTTPS"
    port = 443
  }
  frontend_ip_configuration {
    name                 = "appGatewayFrontendIP"
    public_ip_address_id = "${azurerm_public_ip.AppGw_pip.id}"
  }
  backend_address_pool {
    name            = "FW-Pool"
    ip_address_list = ["${cidrhost("${var.untrust_subnet}", 4)}"]
  }
  backend_http_settings {
    name                  = "HTTP-Backend"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = "30"
  }

  http_listener {
    name                           = "BASIC-HTTP"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "HTTP"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "BASIC-HTTP-FW-POOL"
    rule_type                  = "Basic"
    http_listener_name         = "BASIC-HTTP"
    backend_address_pool_name  = "FW-Pool"
    backend_http_settings_name = "HTTP-Backend"
  }
}
