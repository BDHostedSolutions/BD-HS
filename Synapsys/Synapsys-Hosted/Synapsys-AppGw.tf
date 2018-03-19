resource "azurerm_public_ip" "AppGw_pip" {
  name                         = "AppGw-pip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"
}

resource "azurerm_application_gateway" "App_Gw" {
  name                = "${var.resource_name_prefix}-${var.appgw_name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  sku {
    name     = "Standard_Medium"
    tier     = "Standard"
    capacity = 2
  }

  ssl_certificate {
    name     = "star.carefusionanalytics.com"
    data     = "${var.ssl_data}"
    password = "${var.ssl_password}"
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = "${azurerm_subnet.appgw_subnet.id}"
  }

  authentication_certificate {
    name = "star.carefusionanalytics.com"
    data = "${var.auth_cert_data}"
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

  backend_http_settings {
    name                  = "HTTPS-Backend"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = "30"

    authentication_certificate = {
      name = "star.carefusionanalytics.com"
    }
  }

  http_listener {
    name                           = "BASIC-HTTP"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "HTTP"
    protocol                       = "Http"
  }

  http_listener {
    name                           = "BASIC-HTTPS"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "HTTPS"
    protocol                       = "Https"
    ssl_certificate_name           = "star.carefusionanalytics.com"
  }

  request_routing_rule {
    name                       = "BASIC-HTTP-FW-POOL"
    rule_type                  = "Basic"
    http_listener_name         = "BASIC-HTTP"
    backend_address_pool_name  = "FW-Pool"
    backend_http_settings_name = "HTTP-Backend"
  }

  request_routing_rule {
    name                       = "BASIC-HTTPS-FW-POOL"
    rule_type                  = "Basic"
    http_listener_name         = "BASIC-HTTPS"
    backend_address_pool_name  = "FW-Pool"
    backend_http_settings_name = "HTTPS-Backend"
  }
}
