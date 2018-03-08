resource "azurerm_network_security_group" "rdp_nsg" {
  name                          = "${var.rdp_nsg_name}" 
  location                      = "${var.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  
  security_rule {
    name                        = "Allow-BDNet1"
    description                 = "Allow RDP"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "${var.bdips}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-BDNet2"
    description                 = "Allow RDP"
    priority                    = 101
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "${var.bdips1}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-BDNet3"
    description                 = "Allow RDP"
    priority                    = 102
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "${var.bdips2}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-BDNet4"
    description                 = "Allow RDP"
    priority                    = 103
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "${var.bdips3}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-BDNet1-WD"
    description                 = "Allow WD"
    priority                    = 200
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "8172"
    source_address_prefix       = "${var.bdips}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-BDNet2-WD"
    description                 = "Allow WD"
    priority                    = 201
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "8172"
    source_address_prefix       = "${var.bdips1}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-BDNet3-WD"
    description                 = "Allow WD"
    priority                    = 202
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "8172"
    source_address_prefix       = "${var.bdips2}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-BDNet4-WD"
    description                 = "Allow WD"
    priority                    = 203
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "8172"
    source_address_prefix       = "${var.bdips3}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Block-Local"
    description                 = "Block RDP"
    priority                    = 105
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "VirtualNetwork"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Block-Internet-WD"
    description                 = "Block WD"
    priority                    = 204
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "8172"
    source_address_prefix       = "INTERNET"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Block-Local-WD"
    description                 = "Block WD"
    priority                    = 205
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "8172"
    source_address_prefix       = "VirtualNetwork"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-All"
    description                 = "Allow All"
    priority                    = 500
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "RDP-External"
    priority                    = 104
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
  tags {
    display_name                = "NSG for RDP and Web Deploy in QA"
    description                 = "Applies to each subnet on the QA Vnet"
  }
}