resource "azurerm_availability_set" "db-server-avs" {
  name                = "${var.resource_name_prefix}-${var.db_server_avs_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  managed             = "false"

  tags {
    display_name = "DB Availability Set"
  }
}

resource "azurerm_public_ip" "DB_pip" {
  name                         = "DB-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    display_name = "DB VM0 Public IP"
  }
}

resource "azurerm_network_interface" "db-vm-nic" {
  name                      = "${var.resource_name_prefix}-${var.dbvm_name}-eth0"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"

  tags {
    display_name = "DB VM0 Network Interface"
  }

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.trust_subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.DB_pip.id}"
  }

  depends_on = ["azurerm_network_interface.TRUST"]
}

resource "azurerm_virtual_machine" "db-vm" {
  name                  = "${var.resource_name_prefix}-${var.dbvm_name}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.db-vm-nic.id}"]
  availability_set_id   = "${azurerm_availability_set.db-server-avs.id}"
  vm_size               = "Standard_D3_v2"

  tags {
    display_name = "SQL Server Virtual Machine"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${var.resource_name_prefix}-${var.dbvm_name}_OS"
    vhd_uri       = "${azurerm_storage_account.synapsysprd.primary_blob_endpoint}${azurerm_storage_container.vhds.name}/${var.resource_name_prefix}-${var.dbvm_name}_OS.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.resource_name_prefix}-${var.dbvm_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  depends_on = ["azurerm_storage_account.synapsysprd"]
}

resource "azurerm_virtual_machine_extension" "db0_domain_join" {
  name                 = "join-domain"
  location             = "${azurerm_resource_group.rg.location}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_machine_name = "${azurerm_virtual_machine.db-vm.name}"
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.0"

  settings = <<SETTINGS
    {
        "Name": "hs.local",
        "OUPath": "",
        "User": "hs\\${var.join_domain_user}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "Password": "${var.join_domain_pass}"
    }
PROTECTED_SETTINGS
}