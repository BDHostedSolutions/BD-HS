
resource "azurerm_virtual_machine" "FW" {
  name                         = "${var.firewall_name}"
  location                     = "${data.azurerm_resource_group.DR.location}"
  resource_group_name          = "${data.azurerm_resource_group.DR.name}"
  network_interface_ids        = ["${azurerm_network_interface.MGMT.id}", "${azurerm_network_interface.UNTRUST.id}", "${azurerm_network_interface.TRUST.id}", "${azurerm_network_interface.DMZ.id}"]
  primary_network_interface_id = "${azurerm_network_interface.MGMT.id}"
  availability_set_id          = "${azurerm_availability_set.FWAVS.id}"
  vm_size                      = "Standard_D3_v2"

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
    name          = "${var.firewall_name}_OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
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
