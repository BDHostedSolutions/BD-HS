resource "azurerm_public_ip" "App2_pip" {
  name                         = "App2-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    display_name = "App VM1 Public IP"
  }
}

resource "azurerm_network_interface" "app-vm1-nic" {
  name                      = "${var.resource_name_prefix}-${var.appvm1_name}-eth0"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"

  tags {
    display_name = "App VM1 Network Interface"
  }

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = "${azurerm_subnet.dmz_subnet.id}"
    private_ip_address_allocation           = "dynamic"
  }

  depends_on = ["azurerm_network_interface.DMZ"]
}

resource "azurerm_virtual_machine" "app-vm1" {
  name                  = "${var.resource_name_prefix}-${var.appvm1_name}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.app-vm1-nic.id}"]
  availability_set_id   = "${azurerm_availability_set.app-server-avs.id}"
  vm_size               = "Standard_A3"
  license_type          = "Windows_Server"

  tags {
    display_name = "DS APP Server Virtual Machines"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${var.resource_name_prefix}-${var.appvm1_name}_OS"
    vhd_uri       = "${azurerm_storage_account.synapsysprd.primary_blob_endpoint}${azurerm_storage_container.vhds.name}/${var.resource_name_prefix}-${var.appvm1_name}_OS.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.resource_name_prefix}-${var.appvm1_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  depends_on = ["azurerm_storage_account.synapsysprd"]
}

# resource "azurerm_virtual_machine_extension" "appvm1_domain_join" {
#   name                 = "join-domain"
#   location             = "${azurerm_resource_group.rg.location}"
#   resource_group_name  = "${azurerm_resource_group.rg.name}"
#   virtual_machine_name = "${azurerm_virtual_machine.app-vm1.name}"
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