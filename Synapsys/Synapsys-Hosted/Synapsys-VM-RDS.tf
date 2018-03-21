resource "azurerm_availability_set" "rds-server-avs" {
  name                         = "${var.resource_name_prefix}-${var.rds_server_avs_name}"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  managed                      = false
  platform_update_domain_count = "5"
  platform_fault_domain_count  = "2"
}

resource "azurerm_network_interface" "RDS-NIC" {
  name                = "${var.resource_name_prefix}-${var.rdsvm_name}-eth0"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "RDS"
    subnet_id                     = "${azurerm_subnet.trust_subnet.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost("${var.trust_subnet}", 20)}"
  }

  depends_on = ["azurerm_network_interface.TRUST"]
}

resource "azurerm_virtual_machine" "rdsvm" {
  name                  = "${var.resource_name_prefix}-${var.rdsvm_name}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.RDS-NIC.id}"]
  vm_size               = "Standard_D2"
  license_type          = "Windows_Server"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${var.resource_name_prefix}-${var.rdsvm_name}_OS"
    vhd_uri       = "${azurerm_storage_account.synapsysprd.primary_blob_endpoint}${azurerm_storage_container.vhds.name}/${var.resource_name_prefix}-${var.rdsvm_name}_OS.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.resource_name_prefix}-${var.rdsvm_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

# resource "azurerm_virtual_machine_extension" "rdsvm_domain_join" {
#   name                 = "join-domain"
#   location             = "${azurerm_resource_group.rg.location}"
#   resource_group_name  = "${azurerm_resource_group.rg.name}"
#   virtual_machine_name = "${azurerm_virtual_machine.rdsvm.name}"
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

