resource "azurerm_network_security_group" "splunk_nsg" {
  name                = "${var.splunk_nsg_name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "Allow-BDNet1"
    description                = "Allow 80"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${var.bdips}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet1-SSL"
    description                = "Allow 443"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "${var.bdips}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet2"
    description                = "Allow 80"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${var.bdips1}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet2-SSL"
    description                = "Allow 443"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "${var.bdips1}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet3"
    description                = "Allow 80"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${var.bdips2}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet3-SSL"
    description                = "Allow 443"
    priority                   = 202
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "${var.bdips2}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet4"
    description                = "Allow 80"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${var.bdips3}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet4-SSL"
    description                = "Allow 443"
    priority                   = 203
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "${var.bdips3}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Block-Internet"
    description                = "Block 80"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Block-Internet-SSL"
    description                = "Block 443"
    priority                   = 204
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Shavlik"
    description                = "Allow 4155"
    priority                   = 106
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4155"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Block-RDP"
    description                = "Block 3389"
    priority                   = 107
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Block-WD"
    description                = "Block 8172"
    priority                   = 108
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8172"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    display_name = "NSG for VMs running a Splunk Server"
    description  = "Applies to individual NICs"
  }
}

resource "azurerm_network_security_group" "splunk_rdp_nsg" {
  name                = "${var.splunk_rdp_nsg_name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "Allow-BDNet1"
    description                = "Allow 80"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${var.bdips}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet1-SSL"
    description                = "Allow 443"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "${var.bdips}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet2"
    description                = "Allow 80"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${var.bdips1}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet2-SSL"
    description                = "Allow 443"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "${var.bdips1}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet3"
    description                = "Allow 80"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${var.bdips2}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet3-SSL"
    description                = "Allow 443"
    priority                   = 202
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "${var.bdips2}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet4"
    description                = "Allow 80"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "${var.bdips3}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet4-SSL"
    description                = "Allow 443"
    priority                   = 203
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "${var.bdips3}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Block-Internet"
    description                = "Block 80"
    priority                   = 104
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Block-Internet-SSL"
    description                = "Block 443"
    priority                   = 204
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Shavlik"
    description                = "Allow 4155"
    priority                   = 106
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4155"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-RDP"
    description                = "Allow 3389"
    priority                   = 107
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    display_name = "NSG for VMs running a Splunk Server + RDP"
    description  = "Applies to individual NICs"
  }
}
