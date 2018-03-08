resource "azurerm_network_security_group" "local_sql_nsg" {
  name                          = "${var.local_sql_nsg_name}" 
  location                      = "${var.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  security_rule {
    name                        = "Block-BDNet1"
    description                 = "Block 1433"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "1433"
    source_address_prefix       = "${var.bdips}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Block-BDNet2"
    description                 = "Block 1433"
    priority                    = 101
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "1433"
    source_address_prefix       = "${var.bdips1}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Block-BDNet3"
    description                 = "Block 1433"
    priority                    = 102
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "1433"
    source_address_prefix       = "${var.bdips2}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Block-BDNet4"
    description                 = "Block 1433"
    priority                    = 103
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "1433"
    source_address_prefix       = "${var.bdips3}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Block-Internet"
    description                 = "Block 1433"
    priority                    = 105
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "1433"
    source_address_prefix       = "INTERNET"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-Local"
    description                 = "Allow 1433"
    priority                    = 104
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "1433"
    source_address_prefix       = "VirtualNetwork"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-Shavlik"
    description                 = "Allow 4155"
    priority                    = 106
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "4155"
    source_address_prefix       = "INTERNET"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Block-RDP"
    description                 = "Block 3389"
    priority                    = 107
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Block-WD"
    description                 = "Block 8172"
    priority                    = 108
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "8172"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
  tags {
    display_name                = "NSG for VMs running local vnet SQL Server with RDP Access"
    description                 = "Applies to individual NICs"
  }
}

resource "azurerm_network_security_group" "local_sql_rdp_nsg" {
  name                          = "${var.local_sql_rdp_nsg_name}" 
  location                      = "${var.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  security_rule {
    name                        = "Block-BDNet1"
    description                 = "Block 1433"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "1433"
    source_address_prefix       = "${var.bdips}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Block-BDNet2"
    description                 = "Block 1433"
    priority                    = 101
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "1433"
    source_address_prefix       = "${var.bdips1}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Block-BDNet3"
    description                 = "Block 1433"
    priority                    = 102
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "1433"
    source_address_prefix       = "${var.bdips2}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Block-BDNet4"
    description                 = "Block 1433"
    priority                    = 103
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "1433"
    source_address_prefix       = "${var.bdips3}"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Block-Internet"
    description                 = "Block 1433"
    priority                    = 105
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "1433"
    source_address_prefix       = "INTERNET"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-Local"
    description                 = "Allow 1433"
    priority                    = 104
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "1433"
    source_address_prefix       = "VirtualNetwork"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-Shavlik"
    description                 = "Allow 4155"
    priority                    = 106
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "4155"
    source_address_prefix       = "INTERNET"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-RDP"
    description                 = "Allow 3389"
    priority                    = 107
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
  security_rule {
    name                        = "Allow-WD"
    description                 = "Allow 8172"
    priority                    = 108
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "8172"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
  tags {
    display_name                = "NSG for VMs running local vnet SQL Server with RDP Access"
    description                 = "Applies to individual NICs"
  }
}