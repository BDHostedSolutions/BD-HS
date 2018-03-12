resource "azurerm_resource_group" "vmrg" {
  name     = "${var.vm_resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_availability_set" "FWAVS" {
  name                         = "avs-hs-fw"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.vmrg.name}"
  managed                      = "true"
  platform_update_domain_count = "5"
  platform_fault_domain_count  = "2"
}

resource "azurerm_virtual_machine" "FW" {
  name                         = "${var.firewall_name}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.vmrg.name}"
  network_interface_ids        = ["${azurerm_network_interface.MGMT.id}", "${azurerm_network_interface.UNTRUST.id}", "${azurerm_network_interface.TRUST.id}", "${azurerm_network_interface.DMZ.id}"]
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
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.firewall_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = "false"
  }
}
