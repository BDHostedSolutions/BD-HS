#AppGw
resource "azurerm_application_gateway" "App_Gw" {
  name                = "${var.resource_name_prefix}-${var.AppGw_name}"
  location            = "${azurerm_resource_group.rg.location}"
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
    name            = "IDMCOR-to-FW"
    ip_address_list = ["${cidrhost("${var.untrust_subnet}", 10)}"]
  }

  backend_address_pool {
    name            = "CA-to-FW"
    ip_address_list = ["${cidrhost("${var.untrust_subnet}", 9)}"]
  }

  backend_http_settings {
    name                  = "HTTP-Backend"
    cookie_based_affinity = "Enabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = "30"
  }

  backend_http_settings {
    name                  = "HTTPS-Backend"
    cookie_based_affinity = "Enabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = "60"
    probe_name            = "cacore-probe"

    authentication_certificate = {
      name = "star.carefusionanalytics.com"
    }
  }

  backend_http_settings {
    name                  = "CA-HTTPBackend"
    cookie_based_affinity = "Enabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = "30"
    probe_name            = "ca-probe-http"
  }

  backend_http_settings {
    name                  = "CA-HTTPSBackend"
    cookie_based_affinity = "Enabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = "1800"
    probe_name            = "ca-probe-https"

    authentication_certificate = {
      name = "star.carefusionanalytics.com"
    }
  }

  backend_http_settings {
    name                  = "CAFile-HTTPSBackend"
    cookie_based_affinity = "Enabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = "60"
    probe_name            = "cafile-probe-https"

    authentication_certificate = {
      name = "star.carefusionanalytics.com"
    }
  }

  backend_http_settings {
    name                  = "CAWS-HTTPSBackend"
    cookie_based_affinity = "Enabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = "60"

    authentication_certificate = {
      name = "star.carefusionanalytics.com"
    }
  }

  http_listener {
    name                           = "CA-HTTP"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "HTTP"
    protocol                       = "Http"
    host_name                      = "ca.carefusionanalytics.com"
  }

  http_listener {
    name                           = "CA-HTTPS"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "HTTPS"
    protocol                       = "Https"
    host_name                      = "ca.carefusionanalytics.com"
    ssl_certificate_name           = "star.carefusionanalytics.com"
  }

  http_listener {
    name                           = "CACORE-HTTP"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "HTTP"
    protocol                       = "Http"
    host_name                      = "cacore.carefusionanalytics.com"
  }

  http_listener {
    name                           = "CACORE-HTTPS"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "HTTPS"
    protocol                       = "Https"
    host_name                      = "cacore.carefusionanalytics.com"
    ssl_certificate_name           = "star.carefusionanalytics.com"
  }

  http_listener {
    name                           = "CAFILE-HTTP"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "HTTP"
    protocol                       = "Http"
    host_name                      = "cafile.carefusionanalytics.com"
  }

  http_listener {
    name                           = "CAFILE-HTTPS"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "HTTPS"
    protocol                       = "Https"
    host_name                      = "cafile.carefusionanalytics.com"
    ssl_certificate_name           = "star.carefusionanalytics.com"
  }

  http_listener {
    name                           = "CAWS-HTTP"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "HTTP"
    protocol                       = "Http"
    host_name                      = "caws.carefusionanalytics.com"
  }

  http_listener {
    name                           = "CAWS-HTTPS"
    frontend_ip_configuration_name = "appGatewayFrontendIP"
    frontend_port_name             = "HTTPS"
    protocol                       = "Https"
    host_name                      = "caws.carefusionanalytics.com"
    ssl_certificate_name           = "star.carefusionanalytics.com"
  }

  request_routing_rule {
    name                       = "CA-HTTP-FW"
    rule_type                  = "Basic"
    http_listener_name         = "CA-HTTP"
    backend_address_pool_name  = "CA-to-FW"
    backend_http_settings_name = "CA-HTTPBackend"
  }

  request_routing_rule {
    name                       = "CA-HTTPS-FW"
    rule_type                  = "Basic"
    http_listener_name         = "CA-HTTPS"
    backend_address_pool_name  = "CA-to-FW"
    backend_http_settings_name = "CA-HTTPSBackend"
  }

    request_routing_rule {
    name                       = "CACORE-HTTPS-FW"
    rule_type                  = "Basic"
    http_listener_name         = "CACORE-HTTPS"
    backend_address_pool_name  = "IDMCOR-to-FW"
    backend_http_settings_name = "HTTPSBackend"
  }

  request_routing_rule {
    name                       = "CACORE-HTTP-IDMCOR"
    rule_type                  = "Basic"
    http_listener_name         = "CACORE-HTTP"
    backend_address_pool_name  = "IDMCOR-to-FW"
    backend_http_settings_name = "HTTPBackend"
  }

    request_routing_rule {
    name                       = "CAFILE-HTTP-FW"
    rule_type                  = "Basic"
    http_listener_name         = "CAFILE-HTTP"
    backend_address_pool_name  = "CA-to-FW"
    backend_http_settings_name = "CA-HTTPBackend"
  }

  request_routing_rule {
    name                       = "CAFILE-HTTPS-FW"
    rule_type                  = "Basic"
    http_listener_name         = "CAFILE-HTTPS"
    backend_address_pool_name  = "CA-to-FW"
    backend_http_settings_name = "CA-HTTPSBackend"
  }

    request_routing_rule {
    name                       = "CAWS-HTTP-FW"
    rule_type                  = "Basic"
    http_listener_name         = "CAWS-HTTP"
    backend_address_pool_name  = "CA-to-FW"
    backend_http_settings_name = "CA-HTTPBackend"
  }

  request_routing_rule {
    name                       = "CAWS-HTTPS-FW"
    rule_type                  = "Basic"
    http_listener_name         = "CAWS-HTTPS"
    backend_address_pool_name  = "CA-to-FW"
    backend_http_settings_name = "CAWS-HTTPSBackend"
  }

  probe {
    name                       = "cacore-probe"
    protocol                   = "HTTPS"
    path                       = "/idmsts/ids/login"
    host                       = "cacore.carefusionanalytics.com"
    interval                   = "30"
    timeout                    = "30"
    unhealthy_threshold        = "3"
  }

  probe {
    name                       = "ca-probe-http"
    protocol                   = "HTTP"
    path                       = "/"
    host                       = "ca.carefusionanalytics.com"
    interval                   = "30"
    timeout                    = "30"
    unhealthy_threshold        = "3"
  }

  probe {
    name                       = "ca-probe-https"
    protocol                   = "HTTPS"
    path                       = "/"
    host                       = "ca.carefusionanalytics.com"
    interval                   = "30"
    timeout                    = "30"
    unhealthy_threshold        = "3"
  }

  probe {
    name                       = "cafile-probe-https"
    protocol                   = "HTTPS"
    path                       = "/AgentDownloads/"
    host                       = "cafile.carefusionanalytics.com"
    interval                   = "30"
    timeout                    = "30"
    unhealthy_threshold        = "3"
  }
}
