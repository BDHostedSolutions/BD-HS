resource "azurerm_network_security_group" "nsg_MGMT" {
  name                = "nsg-fw-mgmt"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "Allow-FW-Mgmt"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = [80,443,22]
    source_address_prefixes    = ["204.193.35.248","204.193.35.250","66.194.102.38","216.115.73.53"]
    destination_address_prefix = "${cidrhost("${var.mgmt_subnet}", 4)}"
  }

  security_rule {
    name                       = "Allow-ATL-FW-Mgmt"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "12.129.108.27"
    destination_address_prefix = "${cidrhost("${var.mgmt_subnet}", 4)}"
  }

  security_rule {
    name                       = "Deny-All"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg_UNTRUST" {
  name                = "nsg-fw-untrust"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "LAS-Allow-Inbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "216.115.73.53"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ATL-Allow-Inbound"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "12.129.108.27"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "NonProd-Allow-Inbound"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "206.169.101.200"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Outbound-SD-NonProd"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "206.169.101.200"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg_TRUST" {
  name                = "nsg-fw-trust"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "Allow-LAS"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "216.115.73.53"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg_DMZ" {
  name                = "nsg-fw-dmz"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

}
