resource "azurerm_network_security_group" "nsg_MGMT" {
  name                = "NSG-MGMT"
  location            = "${data.azurerm_resource_group.DR.location}"
  resource_group_name = "${data.azurerm_resource_group.DR.name}"

  security_rule {
    name                       = "Allow-Intra"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "${var.mgmt_subnet}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BHM-FW-Mgmt"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "66.194.102.38"
    destination_address_prefix = "${cidrhost("${var.mgmt_subnet}", 4)}"
  }

  security_rule {
    name                       = "Allow-LAS-FW-Mgmt"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "216.115.73.53"
    destination_address_prefix = "${cidrhost("${var.mgmt_subnet}", 4)}"
  }

  security_rule {
    name                       = "Allow-ATL-FW-Mgmt"
    priority                   = 1300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "12.129.108.27"
    destination_address_prefix = "${cidrhost("${var.mgmt_subnet}", 4)}"
  }

  security_rule {
    name                       = "Default-Deny"
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
  name                = "NSG-UNTRUST"
  location            = "${data.azurerm_resource_group.DR.location}"
  resource_group_name = "${data.azurerm_resource_group.DR.name}"

  security_rule {
    name                       = "Inbound-LAS-Tunnel"
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
    name                       = "Inbound-BHM-Site"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "66.194.102.38"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Inbound-ATL-Tunnel"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "12.129.108.27"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Outbound-LAS-Tunnel"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "216.115.73.53"
  }
}

resource "azurerm_network_security_group" "nsg_TRUST" {
  name                = "NSG-TRUST"
  location            = "${data.azurerm_resource_group.DR.location}"
  resource_group_name = "${data.azurerm_resource_group.DR.name}"

  security_rule {
    name                       = "Inbound-LAS-Tunnel"
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
    name                       = "Inbound-BHM-Site"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "66.194.102.38"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Outbound-LAS-Tunnel"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "216.115.73.53"
  }
}

resource "azurerm_network_security_group" "nsg_DMZ" {
  name                = "NSG-DMZ"
  location            = "${data.azurerm_resource_group.DR.location}"
  resource_group_name = "${data.azurerm_resource_group.DR.name}"

  security_rule {
    name                       = "AllowRDPInBound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 3389
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
