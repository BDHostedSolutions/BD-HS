
resource "azurerm_network_interface" "KPWEB02-NIC" {
  name                      = "${var.resource_name_prefix}-${var.kpweb02_name}-eth0"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg_DMZ.id}"

  ip_configuration {
    name                          = "KPWEB02"
    subnet_id                     = "${azurerm_subnet.dmz_subnet.id}"
    private_ip_address_allocation = "dynamic"
  }

  depends_on = ["azurerm_network_interface.DMZ"]
}

resource "azurerm_virtual_machine" "KPWEB02" {
  name                  = "${var.resource_name_prefix}-${var.kpweb02_name}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.KPAPP-NIC.id}"]
  availability_set_id   = "${azurerm_availability_set.WEBAVS.id}"
  vm_size               = "${var.kpweb_size}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.resource_name_prefix}-${var.kpweb02_name}_OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.resource_name_prefix}-${var.kpweb02_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_windows_config {}

  depends_on = ["azurerm_availability_set.WEBAVS"]
}
