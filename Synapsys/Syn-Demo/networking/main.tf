#----networking/main.tf

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  location            = "${var.rg_location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${var.rg_name}"
}

resource "azurerm_subnet" "demo_subnet" {
  name                      = "sn-demo"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${var.rg_name}"
  address_prefix            = "${var.demo_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_demo.id}"
}

resource "azurerm_network_security_group" "nsg_demo" {
  name                = "${var.demo_nsg_name}"
  location            = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"

  security_rule {
    name                       = "Allow-Internet"
    description                = "Allow 80"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Internet-SSL"
    description                = "Allow 443"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-RDP"
    description                = "Allow 3389"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }
}
