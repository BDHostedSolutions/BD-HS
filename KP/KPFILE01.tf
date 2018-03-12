data "azurerm_image" "KPFILE01-Image" {
  name                = "CustomImage"
  resource_group_name = "shared"
}

resource "azurerm_availability_set" "FILEAVS" {
  name                         = "AVS-CC-KP-FILE"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.vmrg.name}"
  managed                      = "true"
  platform_update_domain_count = "5"
  platform_fault_domain_count  = "2"
}

resource "azurerm_network_interface" "KPFILE-NIC" {
  name                      = "${var.kpfile01_name}-eth0"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.vmrg.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg_TRUST.id}"

  ip_configuration {
    name                          = "KPFILE"
    subnet_id                     = "${azurerm_subnet.trust_subnet.id}"
    private_ip_address_allocation = "dynamic"
  }

  depends_on = ["azurerm_network_interface.TRUST"]
}

resource "azurerm_virtual_machine" "KPFILE01" {
  name                  = "${var.kpfile01_name}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.vmrg.name}"
  network_interface_ids = ["${azurerm_network_interface.KPFILE-NIC.id}"]
  availability_set_id   = "${azurerm_availability_set.FILEAVS.id}"
  vm_size               = "Standard_F4s"

  storage_image_reference {
    id = "${data.azurerm_image.KPFILE01-Image.id}"
  }

  storage_os_disk {
    name              = "${var.kpfile01_name}_OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.kpfile01_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_windows_config {}
}
