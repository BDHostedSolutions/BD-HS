resource "azurerm_public_ip" "splunkvm_pip" {
  name                         = "${var.splunkvm_name}-pip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"
  idle_timeout_in_minutes      = 4
}

resource "azurerm_network_interface" "splunkvm-nic" {
  name                      = "${var.splunkvm_name}-eth0"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.splunk_rdp_nsg.id}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.prod_subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.splunkvm_pip.id}"
  }

  tags {
    display_name = "Splunk NIC"
  }
}

resource "azurerm_virtual_machine" "splunkvm" {
  name                  = "${var.splunkvm_name}"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.splunkvm-nic.id}"]
  availability_set_id   = "${azurerm_availability_set.splunk-avs.id}"
  vm_size               = "Standard_A3"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2012-R2-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${var.splunkvm_name}_OS"
    vhd_uri       = "${azurerm_storage_account.storage_acct.primary_blob_endpoint}${azurerm_storage_container.vhds.name}/${var.splunkvm_name}_OS.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.splunkvm_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  tags {
    display_name = "Splunk Virtual Machine"
  }

  depends_on = ["azurerm_storage_account.storage_acct"]
}

resource "azurerm_virtual_machine_extension" "splunkvm_enablevmaccess" {
  name                       = "${var.splunkvm_name}-EnableVMAccess"
  location                   = "${var.location}"
  resource_group_name        = "${azurerm_resource_group.rg.name}"
  virtual_machine_name       = "${azurerm_virtual_machine.splunkvm.name}"
  publisher                  = "Microsoft.Compute"
  type                       = "VMAccessAgent"
  type_handler_version       = "2.0"
  auto_upgrade_minor_version = true
  settings                   = ""

  depends_on = ["azurerm_virtual_machine.splunkvm"]
}

resource "azurerm_virtual_machine_extension" "splunkvm_iaasantimalware" {
  name                       = "${var.splunkvm_name}-IaaSAntimalware"
  location                   = "${var.location}"
  resource_group_name        = "${azurerm_resource_group.rg.name}"
  virtual_machine_name       = "${azurerm_virtual_machine.splunkvm.name}"
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

  depends_on = ["azurerm_virtual_machine.splunkvm"]
}
