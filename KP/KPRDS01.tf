
resource "azurerm_availability_set" "RDSAVS" {
  name                         = "${var.resource_name_prefix}-KP-RDS-AVS"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  managed                      = "true"
  platform_update_domain_count = "5"
  platform_fault_domain_count  = "2"
}

resource "azurerm_network_interface" "KPRDS-NIC" {
  name                      = "${var.resource_name_prefix}-${var.kprds01_name}-eth0"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg_TRUST.id}"

  ip_configuration {
    name                          = "KPRDS"
    subnet_id                     = "${azurerm_subnet.trust_subnet.id}"
    private_ip_address_allocation = "dynamic"
  }

  depends_on = ["azurerm_network_interface.TRUST"]
}

resource "azurerm_virtual_machine" "KPRDS01" {
  name                  = "${var.resource_name_prefix}-${var.kprds01_name}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.KPRDS-NIC.id}"]
  availability_set_id   = "${azurerm_availability_set.RDSAVS.id}"
  vm_size               = "${var.kprds01_size}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.resource_name_prefix}-${var.kprds01_name}_OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.resource_name_prefix}-${var.kprds01_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_windows_config {}
}
