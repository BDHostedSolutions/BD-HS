resource "azurerm_route_table" "dmz_route_table" {
  name                = "dmz_route_table"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name                   = "default-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.dmz_subnet}", 4)}"
  }

  route {
    name                   = "dmz-to-trust"
    address_prefix         = "${var.trust_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.dmz_subnet}", 4)}"
  }

  route {
    name                   = "route-to-appgw"
    address_prefix         = "${var.appgw_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.dmz_subnet}", 4)}"
  }
}

resource "azurerm_route_table" "trust_route_table" {
  name                = "trust_route_table"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name                   = "default-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "trust-to-dmz"
    address_prefix         = "${var.dmz_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "route-to-appgw"
    address_prefix         = "${var.appgw_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }
}
