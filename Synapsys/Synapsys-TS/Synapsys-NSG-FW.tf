resource "azurerm_network_security_group" "nsg_MGMT" {
  name                = "MGMT-NSG"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "Allow-BHM-FW-Mgmt"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = [443, 80, 22]
    source_address_prefixes    = ["204.193.35.248", "204.193.35.250", "66.194.102.38", "216.115.73.53"]
    destination_address_prefix = "${cidrhost("${var.mgmt_subnet}", 4)}"
  }

  security_rule {
    name                       = "Allow-LAS-FW-Mgmt"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = [443, 80, 22]
    source_address_prefix      = "216.115.73.53"
    destination_address_prefix = "${cidrhost("${var.mgmt_subnet}", 4)}"
  }

  security_rule {
    name                       = "Default-Deny"
    priority                   = 2000
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
  name                = "UNTRUST-NSG"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "Inbound-LAS-VPN-Tunnel"
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
    name                       = "Outbound-LAS-VPN-Tunnel"
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
  name                = "TRUST-NSG"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "Inbound-LAS-VPN-Tunnel"
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
    name                       = "Outbound-LAS-VPN-Tunnel"
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

resource "azurerm_network_security_group" "nsg_HOSTED" {
  name                = "HOSTED-NSG"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "Inbound-LAS-VPN-Tunnel"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "216.115.73.53"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Outbound-LAS-VPN-Tunnel"
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
resource "azurerm_network_security_group" "nsg_syn_dmz" {
  name                = "SYN-DMZ-NSG"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

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

resource "azurerm_network_security_group" "nsg_syn_data" {
  name                = "SYN-DATA-NSG"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "Allow-SYN-DMZ"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "172.16.131.0/24"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SYNRDS01"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "172.16.130.20"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SYNDC01"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "172.16.130.11"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyVnetInBound"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "Allow-To-SYN-DMZ"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "172.16.131.0/24"
  }

  security_rule {
    name                       = "Allow-To-SYNRDS01"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "172.16.130.20"
  }

  security_rule {
    name                       = "Allow-To-SYNDC01"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "172.16.130.11"
  }

  security_rule {
    name                       = "DenyVnetOutBound"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
}

resource "azurerm_network_security_group" "nsg_ts_dmz" {
  name                = "TS-DMZ-NSG"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

security_rule {
    name                       = "Allow-BDNet1"
    description                = "Allow RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${var.bdips}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet2"
    description                = "Allow RDP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${var.bdips1}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet3"
    description                = "Allow RDP"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${var.bdips2}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet4"
    description                = "Allow RDP"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${var.bdips3}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet1-WD"
    description                = "Allow WD"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8172"
    source_address_prefix      = "${var.bdips}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet2-WD"
    description                = "Allow WD"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8172"
    source_address_prefix      = "${var.bdips1}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet3-WD"
    description                = "Allow WD"
    priority                   = 202
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8172"
    source_address_prefix      = "${var.bdips2}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet4-WD"
    description                = "Allow WD"
    priority                   = 203
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8172"
    source_address_prefix      = "${var.bdips3}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Port-80"
    description                = "Allow 80"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Port-443"
    description                = "Allow 443"
    priority                   = 401
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }
}