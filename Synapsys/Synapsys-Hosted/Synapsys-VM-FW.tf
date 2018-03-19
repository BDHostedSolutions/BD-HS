resource "azurerm_availability_set" "FWAVS" {
  name                         = "avs-hs-fw"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  managed                      = false
  platform_update_domain_count = "5"
  platform_fault_domain_count  = "2"
}

resource "azurerm_public_ip" "FW_mgmt_pip" {
  name                         = "FW-mgmt-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_public_ip" "FW_untrust_pip" {
  name                         = "FW-untrust-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "MGMT" {
  name                      = "${var.resource_name_prefix}-${var.firewall_name}-eth0"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg_MGMT.id}"

  ip_configuration {
    name                          = "FW-MGMT"
    subnet_id                     = "${azurerm_subnet.mgmt_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.mgmt_subnet}", 4)}"
    public_ip_address_id          = "${azurerm_public_ip.FW_mgmt_pip.id}"
  }
}

resource "azurerm_network_interface" "UNTRUST" {
  name                      = "${var.resource_name_prefix}-${var.firewall_name}-eth1"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg_UNTRUST.id}"

  ip_configuration {
    name                          = "FW-UNTRUST"
    subnet_id                     = "${azurerm_subnet.untrust_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.untrust_subnet}", 4)}"
    public_ip_address_id          = "${azurerm_public_ip.FW_untrust_pip.id}"
  }
}

resource "azurerm_network_interface" "TRUST" {
  name                      = "${var.resource_name_prefix}-${var.firewall_name}-eth2"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg_TRUST.id}"

  ip_configuration {
    name                          = "FW-TRUST"
    subnet_id                     = "${azurerm_subnet.trust_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.trust_subnet}", 4)}"
  }
}

resource "azurerm_virtual_machine" "FW" {
  name                = "${var.resource_name_prefix}-${var.firewall_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  network_interface_ids = ["${azurerm_network_interface.MGMT.id}", "${azurerm_network_interface.UNTRUST.id}",
    "${azurerm_network_interface.TRUST.id}",
  ]

  primary_network_interface_id = "${azurerm_network_interface.MGMT.id}"
  availability_set_id          = "${azurerm_availability_set.FWAVS.id}"
  vm_size                      = "Standard_D3v2"

  plan {
    name      = "bundle1"
    publisher = "paloaltonetworks"
    product   = "vmseries1"
  }

  storage_image_reference {
    publisher = "paloaltonetworks"
    offer     = "vmseries1"
    sku       = "bundle1"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${var.resource_name_prefix}-${var.firewall_name}_OS"
    vhd_uri       = "${azurerm_storage_account.synapsysprd.primary_blob_endpoint}${azurerm_storage_container.vhds.name}/${var.firewall_name}_OS.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.resource_name_prefix}-${var.firewall_name}"
    admin_username = "${var.fw_username}"
    admin_password = "${var.fw_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = "false"
  }
}