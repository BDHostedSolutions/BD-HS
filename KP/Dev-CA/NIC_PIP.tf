resource "azurerm_public_ip" "AppGw_pip" {
  name                         = "AppGw-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"
}

resource "azurerm_public_ip" "FW_mgmt_pip" {
  name                         = "FW-mgmt-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"
  domain_name_label            = "fwmgmt-kp-dev"
}

resource "azurerm_public_ip" "FW_untrust_pip" {
  name                         = "FW-untrust-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "MGMT" {
  name                          = "${var.resource_name_prefix}-${var.firewall_name}-eth0"
  location                      = "${azurerm_resource_group.rg.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  enable_accelerated_networking = "True"

  ip_configuration {
    name                          = "FW-MGMT"
    subnet_id                     = "${azurerm_subnet.mgmt_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.mgmt_subnet}", 4)}"
    public_ip_address_id          = "${azurerm_public_ip.FW_mgmt_pip.id}"
  }
}

resource "azurerm_network_interface" "UNTRUST" {
  name                          = "${var.resource_name_prefix}-${var.firewall_name}-eth1"
  location                      = "${azurerm_resource_group.rg.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  enable_ip_forwarding          = "True"
  enable_accelerated_networking = "True"

  ip_configuration {
    name                          = "FW-UNTRUST"
    subnet_id                     = "${azurerm_subnet.untrust_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.untrust_subnet}", 4)}"
    public_ip_address_id          = "${azurerm_public_ip.FW_untrust_pip.id}"
    primary                       = "True"
  }

  ip_configuration {
    name                          = "IDMCORE-IP"
    subnet_id                     = "${azurerm_subnet.untrust_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.untrust_subnet}", 10)}"
  }

  ip_configuration {
    name                          = "ILB-IP"
    subnet_id                     = "${azurerm_subnet.untrust_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.untrust_subnet}", 9)}"
  }
}

resource "azurerm_network_interface" "TRUST" {
  name                          = "${var.resource_name_prefix}-${var.firewall_name}-eth2"
  location                      = "${azurerm_resource_group.rg.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  enable_ip_forwarding          = "True"
  enable_accelerated_networking = "True"

  ip_configuration {
    name                          = "FW-TRUST"
    subnet_id                     = "${azurerm_subnet.trust_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.trust_subnet}", 4)}"
  }
}

resource "azurerm_network_interface" "DMZ" {
  name                          = "${var.resource_name_prefix}-${var.firewall_name}-eth3"
  location                      = "${azurerm_resource_group.rg.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  enable_accelerated_networking = "True"

  ip_configuration {
    name                          = "FW-DMZ"
    subnet_id                     = "${azurerm_subnet.dmz_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.dmz_subnet}", 4)}"
  }
}
