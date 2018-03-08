resource "azurerm_resource_group" "rg" {
  name                      = "${var.shared_resource_group_name}"
  location                  = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                      = "${var.vnet_name}"  
  location                  = "${var.location}"
  address_space             = ["${var.address_space}"]
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  dns_servers               = ["${var.dns_server}", "${var.global_dns_server}"]
  tags {
      display_name          = "${var.vnet_name}"
  }
}

resource "azurerm_subnet" "main_subnet" {
  name                      = "${var.subnet1_name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.subnet1_prefix}"
}

resource "azurerm_subnet" "second_subnet" {
  name                      = "${var.subnet2_name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.subnet2_prefix}"
}

