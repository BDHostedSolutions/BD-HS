resource "azurerm_availability_set" "FWAVS" {
  name                         = "${var.resource_name_prefix}-KP-FW-AVS"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  managed                      = "true"
  platform_update_domain_count = "5"
  platform_fault_domain_count  = "2"
}

resource "azurerm_virtual_machine" "FW" {
  name                         = "${var.resource_name_prefix}-${var.firewall_name}"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  network_interface_ids        = ["${azurerm_network_interface.MGMT.id}", "${azurerm_network_interface.UNTRUST.id}", "${azurerm_network_interface.TRUST.id}", "${azurerm_network_interface.DMZ.id}"]
  primary_network_interface_id = "${azurerm_network_interface.MGMT.id}"
  availability_set_id          = "${azurerm_availability_set.FWAVS.id}"
  vm_size                      = "${var.firewall_size}"

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
    name          = "${var.resource_name_prefix}-${var.firewall_name}_OS"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.resource_name_prefix}-${var.firewall_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = "false"
  }

  # boot_diagnostics {
  #   enabled     = true
  #   storage_uri = "${azurerm_storage_account.kptestdev.primary_blob_endpoint}"
  # }
}
