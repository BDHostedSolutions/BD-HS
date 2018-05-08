resource "azurerm_availability_set" "FWAVS" {
  name                         = "${var.resource_name_prefix}-${var.fw_avs_name}"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  managed                      = true
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
  name                = "${var.resource_name_prefix}-${var.firewall_name}-nic0"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "FW-MGMT"
    subnet_id                     = "${azurerm_subnet.mgmt_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.mgmt_subnet}", 4)}"
    public_ip_address_id          = "${azurerm_public_ip.FW_mgmt_pip.id}"
  }
}

resource "azurerm_network_interface" "UNTRUST" {
  name                 = "${var.resource_name_prefix}-${var.firewall_name}-nic1"
  location             = "${azurerm_resource_group.rg.location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "FW-UNTRUST"
    subnet_id                     = "${azurerm_subnet.untrust_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.untrust_subnet}", 4)}"
    public_ip_address_id          = "${azurerm_public_ip.FW_untrust_pip.id}"
  }
}

resource "azurerm_network_interface" "TRUST" {
  name                 = "${var.resource_name_prefix}-${var.firewall_name}-nic2"
  location             = "${azurerm_resource_group.rg.location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  enable_ip_forwarding = true

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
    "${azurerm_network_interface.TRUST.id}"]

  primary_network_interface_id = "${azurerm_network_interface.MGMT.id}"
  availability_set_id          = "${azurerm_availability_set.FWAVS.id}"
  vm_size                      = "${var.fw_vm_size}"

  plan {
    name      = "bundle2"
    publisher = "paloaltonetworks"
    product   = "vmseries1"
  }

  storage_image_reference {
    publisher = "paloaltonetworks"
    offer     = "vmseries1"
    sku       = "bundle2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.resource_name_prefix}-${var.firewall_name}_OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.resource_name_prefix}-${var.firewall_name}"
    admin_username = "${var.fw_username}"
    admin_password = "${var.fw_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = "false"
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.synapsysprd.primary_blob_endpoint}"
  }
}