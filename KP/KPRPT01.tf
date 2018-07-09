resource "azurerm_availability_set" "RPTAVS" {
  name                         = "${var.resource_name_prefix}-KP-SSRS-AVS"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  managed                      = "true"
  platform_update_domain_count = "5"
  platform_fault_domain_count  = "2"
}

resource "azurerm_network_interface" "KPRPT-NIC" {
  name                          = "${var.resource_name_prefix}-${var.kprpt01_name}-eth0"
  location                      = "${azurerm_resource_group.rg.location}"
  resource_group_name           = "${azurerm_resource_group.rg.name}"
  enable_accelerated_networking = "True"

  ip_configuration {
    name                          = "KPRPT"
    subnet_id                     = "${azurerm_subnet.trust_subnet.id}"
    private_ip_address_allocation = "dynamic"
  }

  depends_on = ["azurerm_network_interface.TRUST"]
}

resource "azurerm_virtual_machine" "KPRPT01" {
  name                  = "${var.resource_name_prefix}-${var.kprpt01_name}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.KPRPT-NIC.id}"]
  availability_set_id   = "${azurerm_availability_set.RPTAVS.id}"
  vm_size               = "${var.kprpt01_size}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.resource_name_prefix}-${var.kprpt01_name}_OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.resource_name_prefix}-${var.kprpt01_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

resource "azurerm_virtual_machine_extension" "kprpt01_iaasantimalware" {
  name                       = "${var.resource_name_prefix}-${var.kprpt01_name}-IaaSAntimalware"
  location                   = "${azurerm_resource_group.rg.location}"
  resource_group_name        = "${azurerm_resource_group.rg.name}"
  virtual_machine_name       = "${azurerm_virtual_machine.KPRPT01.name}"
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.5"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "AntimalwareEnabled": "true",
        "ScheduledScanSettings": {
            "isEnabled": "true",
            "scanType": "Quick",
            "day": "7",
            "time": "120"
        },
        "Exclusions": {
            "Paths": "C:\\Users",
            "Extensions": ".txt",
            "Processes": "taskmgr.exe"
        },
        "RealtimeProtectionEnabled": "true"
    }
  SETTINGS

  depends_on = ["azurerm_virtual_machine.KPRPT01"]
}
