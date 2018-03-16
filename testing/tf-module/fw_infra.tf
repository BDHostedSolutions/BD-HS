# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  location            = "${var.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${var.resource_group_name}"
  dns_servers         = ["${var.dns_server}", "${var.global_dns_server}"]

  tags {
    display_name = "${var.vnet_name}"
  }
}

# Virtual Network Subnets
resource "azurerm_subnet" "mgmt_subnet" {
  name                      = "sn-mgmt"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${var.resource_group_name}"
  address_prefix            = "${var.mgmt_subnet}"
}

resource "azurerm_subnet" "untrust_subnet" {
  name                      = "sn-untrust"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${var.resource_group_name}"
  address_prefix            = "${var.untrust_subnet}"
}

resource "azurerm_subnet" "trust_subnet" {
  name                      = "sn-trust"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${var.resource_group_name}"
  address_prefix            = "${var.trust_subnet}"
}

#Storage Account & Container for FW vhd file
resource "azurerm_storage_account" "FW"{
  name                     = "${var.storage_acct_name}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags {
    display_name = "storageaccount"
  }
}

resource "azurerm_storage_container" "vhds" {
  name                  = "vhds"
  resource_group_name   = "${var.resource_group_name}"
  storage_account_name  = "${var.storage_acct_name}"
  container_access_type = "private"

  depends_on = ["azurerm_storage_account.FW"]
}

# FW Availability Set
resource "azurerm_availability_set" "FWAVS" {
  name                         = "${var.fwavs_name}"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  managed                      = false
  platform_update_domain_count = "5"
  platform_fault_domain_count  = "2"
}

# Public IPs for Mgmt & Untrust NICs
resource "azurerm_public_ip" "FW_mgmt_pip" {
  name                         = "FW-mgmt-pip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_public_ip" "FW_untrust_pip" {
  name                         = "FW-untrust-pip"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group_name}"
  public_ip_address_allocation = "static"
}

# FW NICs (MGMT, UNTRUST, TRUST)
resource "azurerm_network_interface" "MGMT" {
  name                      = "${var.firewall_name}-eth0"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"

  ip_configuration {
    name                          = "FW-MGMT"
    subnet_id                     = "${azurerm_subnet.mgmt_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.mgmt_subnet}", 4)}"
    public_ip_address_id          = "${azurerm_public_ip.FW_mgmt_pip.id}"
  }
}

resource "azurerm_network_interface" "UNTRUST" {
  name                      = "${var.firewall_name}-eth1"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"

  ip_configuration {
    name                          = "FW-UNTRUST"
    subnet_id                     = "${azurerm_subnet.untrust_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.untrust_subnet}", 4)}"
    public_ip_address_id          = "${azurerm_public_ip.FW_untrust_pip.id}"
  }
}

resource "azurerm_network_interface" "TRUST" {
  name                      = "${var.firewall_name}-eth2"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"

  ip_configuration {
    name                          = "FW-TRUST"
    subnet_id                     = "${azurerm_subnet.trust_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.trust_subnet}", 4)}"
  }
}

# FW Virtual Machine (Linux)
resource "azurerm_virtual_machine" "FW" {
  name                = "${var.firewall_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  network_interface_ids = [
    "${azurerm_network_interface.MGMT.id}", 
    "${azurerm_network_interface.UNTRUST.id}",
    "${azurerm_network_interface.TRUST.id}"
  ]

  primary_network_interface_id = "${azurerm_network_interface.MGMT.id}"
  availability_set_id          = "${azurerm_availability_set.FWAVS.id}"
  vm_size                      = "Standard_D3_v2"

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
    name          = "${var.firewall_name}_OS"
    vhd_uri       = "${azurerm_storage_account.FW.primary_blob_endpoint}${azurerm_storage_container.vhds.name}/${var.firewall_name}_OS.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.firewall_name}"
    admin_username = "${var.fw_username}"
    admin_password = "${var.fw_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = "false"
  }
}