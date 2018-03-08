resource "azurerm_public_ip" "calinux_pip" {
    name                                = "calinux-pip"
    location                            = "${var.location}"
    resource_group_name                 = "${azurerm_resource_group.rg.name}"
    public_ip_address_allocation        = "dynamic"
    idle_timeout_in_minutes             = 4
    tags {
        display_name                    = "UbuntuPublicIP"
      }
}

resource "azurerm_network_interface" "calinux-nic" {
    name                                = "${var.calinux_name}-eth0"
    location                            = "${var.location}"
    resource_group_name                 = "${azurerm_resource_group.rg.name}"
    tags {
        display_name                    = "UbuntuCAServerNic"
      }

    ip_configuration {
        name                            = "ipconfig1"
        subnet_id                       = "${azurerm_subnet.prod_subnet.id}"
        private_ip_address_allocation   = "dynamic"
        public_ip_address_id            = "${azurerm_public_ip.calinux_pip.id}"
    }
}

resource "azurerm_virtual_machine" "calinux" {
    name                                = "${var.calinux_name}"
    location                            = "${var.location}"
    resource_group_name                 = "${azurerm_resource_group.rg.name}"
    network_interface_ids               = ["${azurerm_network_interface.calinux-nic.id}"]
    availability_set_id                 = "${azurerm_availability_set.calinux-avs.id}"
    vm_size                             = "Basic_A1"
    tags {
        display_name                    = "UbuntuCAServer"
    }
    storage_image_reference {
        publisher                       = "Canonical"
        offer                           = "UbuntuServer"
        sku                             = "14.04.2-LTS"
        version                         = "latest"
    }

    storage_os_disk {
        name                            = "${var.calinux_name}_OS"
        vhd_uri                         = "${azurerm_storage_account.storage_acct.primary_blob_endpoint}${azurerm_storage_container.vhds.name}/${var.calinux_name}_OS.vhd"
        caching                         = "ReadWrite"
        create_option                   = "FromImage"
    }

    os_profile {
        computer_name                   = "${var.calinux_name}"
        admin_username                  = "${var.vm_username}"
        admin_password                  = "${var.vm_password}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    depends_on                          = ["azurerm_storage_account.storage_acct"]
}

resource "azurerm_virtual_machine_extension" "calinux_enablevmaccess" {
  name                                  = "${var.calinux_name}-EnableVMAccess"
  location                              = "${var.location}"
  resource_group_name                   = "${azurerm_resource_group.rg.name}"
  virtual_machine_name                  = "${azurerm_virtual_machine.calinux.name}"
  publisher                             = "Microsoft.OSTCExtensions"
  type                                  = "VMAccessForLinux"
  type_handler_version                  = "1.4"
  auto_upgrade_minor_version            = true
  settings                              = ""
  protected_settings                    = <<SETTINGS
  {
        "username": "bdiadmin",
        "password": "!Syn@PSys2018!"
  }
  SETTINGS

  depends_on                            = ["azurerm_virtual_machine.calinux"]
}

