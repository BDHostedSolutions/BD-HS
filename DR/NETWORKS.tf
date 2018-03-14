data "azurerm_resource_group" "DR" {
  name = "HS-DR-EastUS2-RG-01"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "HS-DR-EastUS2-vnet"
  location            = "${data.azurerm_resource_group.DR.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${data.azurerm_resource_group.DR.name}"
}

resource "azurerm_subnet" "mgmt_subnet" {
  name                      = "sn-mgmt"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${data.azurerm_resource_group.DR.name}"
  address_prefix            = "${var.mgmt_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_MGMT.id}"
}

resource "azurerm_subnet" "untrust_subnet" {
  name                      = "sn-untrust"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${data.azurerm_resource_group.DR.name}"
  address_prefix            = "${var.untrust_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_UNTRUST.id}"
}

# resource "azurerm_subnet" "trust_subnet" {
#   name                      = "sn-trust"
#   virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
#   resource_group_name       = "${data.azurerm_resource_group.DR.name}"
#   address_prefix            = "${var.trust_subnet}"
#   network_security_group_id = "${azurerm_network_security_group.nsg_TRUST.id}"
#   route_table_id            = "${azurerm_route_table.trust_route_table.id}"
# }

resource "azurerm_subnet" "dmz_subnet" {
  name                      = "sn-dmz"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${data.azurerm_resource_group.DR.name}"
  address_prefix            = "${var.dmz_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_DMZ.id}"
  route_table_id            = "${azurerm_route_table.dmz_route_table.id}"
}

resource "azurerm_subnet" "mm_subnet" {
  name                 = "sn-medmined"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.DR.name}"
  address_prefix       = "${var.mm_subnet}"
}

resource "azurerm_subnet" "hs_subnet" {
  name                 = "sn-hs"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.DR.name}"
  address_prefix       = "${var.hs_subnet}"
  route_table_id       = "${azurerm_route_table.hs_route_table.id}"
}

resource "azurerm_subnet" "appgw_subnet" {
  name                 = "sn-appgw"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.DR.name}"
  address_prefix       = "${var.appgw_subnet}"
}
