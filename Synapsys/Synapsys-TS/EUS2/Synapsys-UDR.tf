resource "azurerm_route_table" "trust_route_table" {
  name                = "trust_route_table"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name                   = "internet-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "untrust-route"
    address_prefix         = "${var.untrust_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "appgw-route"
    address_prefix         = "${var.appgw_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "hosted-route"
    address_prefix         = "${var.hosted_subnet}"
    next_hop_type          = "VnetLocal"
  }

  route {
    name                   = "syn-dmz-route"
    address_prefix         = "${var.syn_dmz_subnet}"
    next_hop_type          = "VnetLocal"
  }

  route {
    name                   = "syn-data-route"
    address_prefix         = "${var.syn_data_subnet}"
    next_hop_type          = "VnetLocal"
  }

  route {
    name                   = "ts-dmz-route"
    address_prefix         = "${var.ts_dmz_subnet}"
    next_hop_type          = "VnetLocal"
  }

  route {
    name                   = "block-mgmt"
    address_prefix         = "${var.mgmt_subnet}"
    next_hop_type          = "None"
  }
}

resource "azurerm_route_table" "syn_dmz_route_table" {
  name                = "syn_dmz_route_table"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name                   = "internet-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "hosted-route"
    address_prefix         = "${var.hosted_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "syn-data-route"
    address_prefix         = "${var.syn_data_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "ts-dmz-route"
    address_prefix         = "${var.ts_dmz_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "appgw-route"
    address_prefix         = "${var.appgw_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "untrust-route"
    address_prefix         = "${var.untrust_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "block-mgmt"
    address_prefix         = "${var.mgmt_subnet}"
    next_hop_type          = "None"
  }

  route {
    name                   = "shavlik-route"
    address_prefix         = "172.16.0.9/32"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }
}

resource "azurerm_route_table" "syn_data_route_table" {
  name                = "syn_data_route_table"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name                   = "internet-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "hosted-route"
    address_prefix         = "${var.hosted_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "syn-dmz-route"
    address_prefix         = "${var.syn_dmz_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "ts-dmz-route"
    address_prefix         = "${var.ts_dmz_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "appgw-route"
    address_prefix         = "${var.appgw_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "untrust-route"
    address_prefix         = "${var.untrust_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "block-mgmt"
    address_prefix         = "${var.mgmt_subnet}"
    next_hop_type          = "None"
  }

  route {
    name                   = "shavlik-route"
    address_prefix         = "172.16.0.9/32"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }
}

resource "azurerm_route_table" "ts_dmz_route_table" {
  name                = "ts_dmz_route_table"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name                   = "internet-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "hosted-route"
    address_prefix         = "${var.hosted_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "syn-dmz-route"
    address_prefix         = "${var.syn_dmz_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "syn-data-route"
    address_prefix         = "${var.syn_data_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "appgw-route"
    address_prefix         = "${var.appgw_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "untrust-route"
    address_prefix         = "${var.untrust_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "block-mgmt"
    address_prefix         = "${var.mgmt_subnet}"
    next_hop_type          = "None"
  }

  route {
    name                   = "shavlik-route"
    address_prefix         = "172.16.0.9/32"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }
}

resource "azurerm_route_table" "hosted_route_table" {
  name                = "hosted_route_table"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name                   = "appgw-route"
    address_prefix         = "${var.appgw_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "block-mgmt"
    address_prefix         = "${var.mgmt_subnet}"
    next_hop_type          = "None"
  }

  route {
    name                   = "internet-route"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "syn-data-route"
    address_prefix         = "${var.syn_data_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "syn-dmz-route"
    address_prefix         = "${var.syn_dmz_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "ts-dmz-route"
    address_prefix         = "${var.ts_dmz_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "untrust-route"
    address_prefix         = "${var.untrust_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }

  route {
    name                   = "shavlik-route"
    address_prefix         = "172.16.0.9/32"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.trust_subnet}", 4)}"
  }
}

resource "azurerm_route_table" "appgw_route_table" {
  name                = "appgw_route_table"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  route {
    name                   = "route_to_syn_dmz"
    address_prefix         = "${var.syn_dmz_subnet}"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "${cidrhost("${var.untrust_subnet}", 4)}"
  }
}