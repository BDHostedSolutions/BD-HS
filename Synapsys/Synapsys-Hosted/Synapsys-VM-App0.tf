resource "azurerm_availability_set" "app-server-avs" {
  name                = "${var.resource_name_prefix}-${var.app_server_avs_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  managed             = false

  tags {
    display_name = "App Availability Set"
  }
}

resource "azurerm_public_ip" "App_pip" {
  name                         = "App-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    display_name = "App VM0 Public IP"
  }
}

resource "azurerm_network_interface" "app-vm0-nic" {
  name                = "${var.resource_name_prefix}-${var.appvm0_name}-eth0"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  tags {
    display_name = "App VM0 Network Interface"
  }

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.dmz_subnet.id}"
    private_ip_address_allocation = "dynamic"
  }

  depends_on = ["azurerm_network_interface.DMZ"]
}

resource "azurerm_virtual_machine" "app-vm0" {
  name                  = "${var.resource_name_prefix}-${var.appvm0_name}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.app-vm0-nic.id}"]
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
    name          = "${var.resource_name_prefix}-${var.appvm0_name}_OS"
    vhd_uri       = "${azurerm_storage_account.synapsysprd.primary_blob_endpoint}${azurerm_storage_container.vhds.name}/${var.resource_name_prefix}-${var.appvm0_name}_OS.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.resource_name_prefix}-${var.appvm0_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  depends_on = ["azurerm_storage_account.synapsysprd"]
}

# resource "azurerm_virtual_machine_extension" "appvm0_domain_join" {
#   name                 = "join-domain"
#   location             = "${azurerm_resource_group.rg.location}"
#   resource_group_name  = "${azurerm_resource_group.rg.name}"
#   virtual_machine_name = "${azurerm_virtual_machine.app-vm0.name}"
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

