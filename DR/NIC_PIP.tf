resource "azurerm_public_ip" "AppGw_pip" {
    name                            = "AppGw-pip"
    location                        = "${data.azurerm_resource_group.DR.location}"
    resource_group_name             = "${data.azurerm_resource_group.DR.name}"
    public_ip_address_allocation    = "dynamic"
}

resource "azurerm_public_ip" "FW_mgmt_pip" {
    name                            = "FW-mgmt-pip"
    location                        = "${data.azurerm_resource_group.DR.location}"
    resource_group_name             = "${data.azurerm_resource_group.DR.name}"
    public_ip_address_allocation    = "static"
}

resource "azurerm_public_ip" "FW_untrust_pip" {
    name                            = "FW-untrust-pip"
    location                        = "${data.azurerm_resource_group.DR.location}"
    resource_group_name             = "${data.azurerm_resource_group.DR.name}"
    public_ip_address_allocation    = "static"
}

resource "azurerm_network_interface" "MGMT" {
    name                        = "${var.firewall_name}-eth0"
    location                    = "${data.azurerm_resource_group.DR.location}"
    resource_group_name         = "${data.azurerm_resource_group.DR.name}"
    network_security_group_id   = "${azurerm_network_security_group.nsg_MGMT.id}"

    ip_configuration {
        name                            = "FW-MGMT"
        subnet_id                       = "${azurerm_subnet.mgmt_subnet.id}"
        private_ip_address_allocation   = "static"
        private_ip_address              = "${cidrhost("${var.mgmt_subnet}", 4)}"
        public_ip_address_id            = "${azurerm_public_ip.FW_mgmt_pip.id}"
    }
}

resource "azurerm_network_interface" "UNTRUST" {
    name                        = "${var.firewall_name}-eth1"
    location                    = "${data.azurerm_resource_group.DR.location}"
    resource_group_name         = "${data.azurerm_resource_group.DR.name}"
    network_security_group_id   = "${azurerm_network_security_group.nsg_UNTRUST.id}"

    ip_configuration {
        name                            = "FW-UNTRUST"
        subnet_id                       = "${azurerm_subnet.untrust_subnet.id}"
        private_ip_address_allocation   = "static"
        private_ip_address              = "${cidrhost("${var.untrust_subnet}", 4)}"
        public_ip_address_id            = "${azurerm_public_ip.FW_untrust_pip.id}"
    }
}

resource "azurerm_network_interface" "TRUST" {
    name                        = "${var.firewall_name}-eth2"
    location                    = "${data.azurerm_resource_group.DR.location}"
    resource_group_name         = "${data.azurerm_resource_group.DR.name}"
    network_security_group_id   = "${azurerm_network_security_group.nsg_TRUST.id}"

    ip_configuration {
        name                            = "FW-TRUST"
        subnet_id                       = "${azurerm_subnet.trust_subnet.id}"
        private_ip_address_allocation   = "static"
        private_ip_address              = "${cidrhost("${var.trust_subnet}", 4)}"
    }
}

resource "azurerm_network_interface" "DMZ" {
    name                        = "${var.firewall_name}-eth3"
    location                    = "${data.azurerm_resource_group.DR.location}"
    resource_group_name         = "${data.azurerm_resource_group.DR.name}"
    network_security_group_id   = "${azurerm_network_security_group.nsg_DMZ.id}"

    ip_configuration {
        name                            = "FW-DMZ"
        subnet_id                       = "${azurerm_subnet.dmz_subnet.id}"
        private_ip_address_allocation   = "static"
        private_ip_address              = "${cidrhost("${var.dmz_subnet}", 4)}"
    }
}