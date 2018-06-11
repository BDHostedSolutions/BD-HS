resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  location            = "${azurerm_resource_group.rg.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
  dns_servers         = ["${var.dns_server}", "${var.global_dns_server}"]

  tags {
    display_name = "${var.vnet_name}"
  }
}

resource "azurerm_subnet" "mgmt_subnet" {
  name                      = "sn-mgmt"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.mgmt_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_MGMT.id}"
}

resource "azurerm_subnet" "untrust_subnet" {
  name                      = "sn-untrust"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.untrust_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_UNTRUST.id}"
  route_table_id            = "${azurerm_route_table.untrust_route_table.id}"
}

resource "azurerm_subnet" "trust_subnet" {
  name                      = "sn-trust"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.trust_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_TRUST.id}"
  route_table_id            = "${azurerm_route_table.trust_route_table.id}"
}

resource "azurerm_subnet" "syn_dmz_subnet" {
  name                      = "sn-syn-dmz"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.syn_dmz_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_syn_dmz.id}"
  route_table_id            = "${azurerm_route_table.syn_dmz_route_table.id}"
}

resource "azurerm_subnet" "syn_data_subnet" {
  name                      = "sn-syn-data"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.syn_data_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_syn_data.id}"
  route_table_id            = "${azurerm_route_table.syn_data_route_table.id}"
}

resource "azurerm_subnet" "ts_dmz_subnet" {
  name                      = "sn-ts-dmz"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.ts_dmz_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_ts_dmz.id}"
  route_table_id            = "${azurerm_route_table.ts_dmz_route_table.id}"
}

resource "azurerm_subnet" "hosted_subnet" {
  name                      = "sn-hosted"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.hosted_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_HOSTED.id}"
  route_table_id            = "${azurerm_route_table.hosted_route_table.id}"
}

resource "azurerm_subnet" "appgw_subnet" {
  name                 = "sn-appgw"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefix       = "${var.appgw_subnet}"
}
