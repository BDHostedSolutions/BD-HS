resource "azurerm_availability_set" "ssis-avs" {
  name                = "${var.ssis_avs_name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  managed             = true
}

resource "azurerm_public_ip" "ssisvm0_pip" {
  name                         = "${var.ssisvm0_name}-pip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"
  idle_timeout_in_minutes      = 4
}

resource "azurerm_network_interface" "ssisvm0-nic" {
  name                      = "${var.ssisvm0_name}-eth0"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.local_sql_rdp_nsg.id}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.stg_subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.ssisvm0_pip.id}"
  }
}

resource "azurerm_virtual_machine" "ssisvm0" {
  name                  = "${var.ssisvm0_name}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.ssisvm0-nic.id}"]
  availability_set_id   = "${azurerm_availability_set.ssis-avs.id}"
  vm_size               = "Standard_A3"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${var.ssisvm0_name}_OS"
    caching       = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.ssisvm0_name}"
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

resource "azurerm_virtual_machine_extension" "ssisvm0_enablevmaccess" {
  name                       = "${var.ssisvm0_name}-EnableVMAccess"
  location                   = "${var.location}"
  resource_group_name        = "${azurerm_resource_group.rg.name}"
  virtual_machine_name       = "${azurerm_virtual_machine.ssisvm0.name}"
  publisher                  = "Microsoft.Compute"
  type                       = "VMAccessAgent"
  type_handler_version       = "2.0"
  auto_upgrade_minor_version = true
  settings                   = ""

  depends_on = ["azurerm_virtual_machine.ssisvm0"]
}

resource "azurerm_virtual_machine_extension" "ssisvm0_iaasantimalware" {
  name                       = "${var.ssisvm0_name}-IaaSAntimalware"
  location                   = "${var.location}"
  resource_group_name        = "${azurerm_resource_group.rg.name}"
  virtual_machine_name       = "${azurerm_virtual_machine.ssisvm0.name}"
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

  depends_on = ["azurerm_virtual_machine.ssisvm0"]
}