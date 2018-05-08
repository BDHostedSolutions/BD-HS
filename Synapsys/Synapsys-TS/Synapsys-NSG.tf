resource "azurerm_network_security_group" "nsg_RDP" {
  name                = "${var.rdp_nsg_name}"
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
    name                       = "Block-Internet"
    description                = "Block RDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Block-Local"
    description                = "Block RDP"
    priority                   = 301
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Block-Internet-WD"
    description                = "Block WD"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8172"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Block-Local-WD"
    description                = "Block WD"
    priority                   = 401
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8172"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-All"
    description                = "Allow All"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    display_name = "NSG for RDP and Web Deploy"
    description  = "Applies to each subnet on the Vnet"
  }
}

resource "azurerm_network_security_group" "nsg_App1" {
  name                = "${var.app1_nsg_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

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
    name                       = "Allow-Local"
    description                = "Allow 80"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "VirtualNetwork"
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
    name                       = "Allow-Local-SSL"
    description                = "Allow 443"
    priority                   = 210
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Shavlik"
    description                = "Allow 4155"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4155"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  tags {
    display_name = "NSG for Web Service-ext access"
    description  = "Applies to each NIC"
  }
}

resource "azurerm_network_security_group" "nsg_App2" {
  name                = "${var.app2_nsg_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

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
    name                       = "Allow-Local"
    description                = "Allow 80"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "VirtualNetwork"
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
    name                       = "Allow-Local-SSL"
    description                = "Allow 443"
    priority                   = 210
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Shavlik"
    description                = "Allow 4155"
    priority                   = 300
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
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-WD"
    description                = "Allow 8172"
    priority                   = 401
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8172"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg_DB1" {
  name                = "${var.db1_nsg_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "Allow-Local"
    description                = "Allow 1433"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Block-Internet"
    description                = "Deny 1433"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Shavlik"
    description                = "Allow 4155"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4155"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg_DB2" {
  name                = "${var.db2_nsg_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "Allow-Local"
    description                = "Allow 1433"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet1"
    description                = "Allow 1433"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "${var.bdips}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet2"
    description                = "Allow 1433"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "${var.bdips1}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet3"
    description                = "Allow 1433"
    priority                   = 202
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "${var.bdips2}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-BDNet4"
    description                = "Allow 1433"
    priority                   = 203
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "${var.bdips3}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Block-Internet"
    description                = "Deny 1433"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Shavlik"
    description                = "Allow 4155"
    priority                   = 400
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
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "INTERNET"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-WD"
    description                = "Allow 8172"
    priority                   = 501
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8172"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
