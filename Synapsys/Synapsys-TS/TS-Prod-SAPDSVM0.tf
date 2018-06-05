resource "azurerm_availability_set" "sapds-avs" {
  name                = "${var.resource_name_prefix}-${var.sapds_avs_name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  managed             = true
}

resource "azurerm_network_interface" "sapdsvm0-nic" {
  name                = "${var.resource_name_prefix}-${var.sapdsvm0_name}-eth0"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.ts_dmz_subnet.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "sapdsvm0" {
  name                  = "${var.resource_name_prefix}-${var.sapdsvm0_name}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.sapdsvm0-nic.id}"]
  availability_set_id   = "${azurerm_availability_set.sapds-avs.id}"
  vm_size               = "${var.sap_vm_size}"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.resource_name_prefix}-${var.sapdsvm0_name}_OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.resource_name_prefix}-SAPDS"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.synapsysprd.primary_blob_endpoint}"
  }
}

resource "azurerm_virtual_machine_extension" "sapdsvm0_iaasantimalware" {
  name                       = "${var.resource_name_prefix}-${var.sapdsvm0_name}-IaaSAntimalware"
  location                   = "${var.location}"
  resource_group_name        = "${azurerm_resource_group.rg.name}"
  virtual_machine_name       = "${azurerm_virtual_machine.sapdsvm0.name}"
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.3"
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

  depends_on = ["azurerm_virtual_machine.sapdsvm0"]
}
