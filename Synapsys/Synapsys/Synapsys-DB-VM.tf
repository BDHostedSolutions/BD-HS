resource "azurerm_availability_set" "db-server-avs" {
    name                                = "${var.db_server_avs_name}"
    location                            = "${var.location}"
    resource_group_name                 = "${azurerm_resource_group.rg.name}"
    managed                             = "false"
    tags {
        display_name                    = "AvailabilitySet"
      }
}

resource "azurerm_public_ip" "DB_pip" {
    name                                = "DB-pip"
    location                            = "${var.location}"
    resource_group_name                 = "${azurerm_resource_group.rg.name}"
    public_ip_address_allocation        = "dynamic"
    tags {
        display_name                    = "Public IP"
      }
}

resource "azurerm_network_interface" "db-vm-nic" {
    name                                = "${var.dbvm_name}-eth0"
    location                            = "${var.location}"
    resource_group_name                 = "${azurerm_resource_group.rg.name}"
    network_security_group_id           = "${azurerm_network_security_group.nsg_DB1.id}"
    tags {
        display_name                    = "NetworkInterface"
      }

    ip_configuration {
        name                            = "ipconfig1"
        subnet_id                       = "${azurerm_subnet.main_subnet.id}"
        private_ip_address_allocation   = "dynamic"
        public_ip_address_id            = "${azurerm_public_ip.DB_pip.id}"
    }
}

resource "azurerm_virtual_machine" "db-vm" {
    name                                = "${var.dbvm_name}"
    location                            = "${var.location}"
    resource_group_name                 = "${azurerm_resource_group.rg.name}"
    network_interface_ids               = ["${azurerm_network_interface.db-vm-nic.id}"]
    availability_set_id                 = "${azurerm_availability_set.db-server-avs.id}"
    vm_size                             = "Standard_D3_v2"
    tags {
        display_name                    = "SQL Server Virtual Machine"
    }
    storage_image_reference {
        publisher                       = "MicrosoftWindowsServer"
        offer                           = "WindowsServer"
        sku                             = "2016-Datacenter"
        version                         = "latest"
    }

    storage_os_disk {
        name                            = "${var.dbvm_name}_OS"
        vhd_uri                         = "${azurerm_storage_account.synapsysprd.primary_blob_endpoint}${azurerm_storage_container.vhds.name}/${var.dbvm_name}_OS.vhd"
        caching                         = "ReadWrite"
        create_option                   = "FromImage"
    }

    os_profile {
        computer_name                   = "${var.dbvm_name}"
        admin_username                  = "${var.vm_username}"
        admin_password                  = "${var.vm_password}"
    }

    os_profile_windows_config {

    }

    depends_on                          = ["azurerm_storage_account.synapsysprd"]
}


