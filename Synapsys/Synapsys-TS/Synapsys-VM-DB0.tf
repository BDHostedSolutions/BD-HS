resource "azurerm_availability_set" "db-server-avs" {
  name                = "${var.resource_name_prefix}-${var.db_server_avs_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  managed             = true
}

resource "azurerm_network_interface" "db-vm-nic" {
  name                = "${var.resource_name_prefix}-${var.dbvm_name}-nic0"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.syn_data_subnet.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "db-vm" {
  name                  = "${var.resource_name_prefix}-${var.dbvm_name}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.db-vm-nic.id}"]
  availability_set_id   = "${azurerm_availability_set.db-server-avs.id}"
  vm_size               = "${var.sql_vm_size}"
  license_type          = "Windows_Server" # Hybrid Benefit

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.resource_name_prefix}-${var.dbvm_name}_OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "128"
  }

  os_profile {
    computer_name  = "${var.resource_name_prefix}-${var.dbvm_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.synapsysprd.primary_blob_endpoint}"
  }
}

resource "azurerm_virtual_machine_extension" "db-vm_iaasantimalware" {
  name                       = "${var.resource_name_prefix}-${var.dbvm_name}-IaaSAntimalware"
  location                   = "${azurerm_resource_group.rg.location}"
  resource_group_name        = "${azurerm_resource_group.rg.name}"
  virtual_machine_name       = "${azurerm_virtual_machine.db-vm.name}"
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

  depends_on = ["azurerm_virtual_machine.db-vm"]
}

# resource "azurerm_virtual_machine_extension" "db0_domain_join" {
#   name                 = "join-domain"
#   location             = "${azurerm_resource_group.rg.location}"
#   resource_group_name  = "${azurerm_resource_group.rg.name}"
#   virtual_machine_name = "${azurerm_virtual_machine.db-vm.name}"
#   publisher            = "Microsoft.Compute"
#   type                 = "JsonADDomainExtension"
#   type_handler_version = "1.0"


#   settings = <<SETTINGS
#     {
#         "Name": "hs.local",
#         "OUPath": "",
#         "User": "hs\\${var.join_domain_user}",
#         "Restart": "true",
#         "Options": "3"
#     }
# SETTINGS


#   protected_settings = <<PROTECTED_SETTINGS
#     {
#         "Password": "${var.join_domain_pass}"
#     }
# PROTECTED_SETTINGS
# }

