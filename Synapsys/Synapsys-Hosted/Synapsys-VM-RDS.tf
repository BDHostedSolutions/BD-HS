resource "azurerm_network_interface" "RDS-NIC" {
    name                        = "${var.rds01_name}-eth0"
    location                    = "${var.location}"
    resource_group_name         = "${azurerm_resource_group.rg.name}"
    network_security_group_id   = "${azurerm_network_security_group.nsg_TRUST.id}"

    ip_configuration {
        name                            = "RDS"
        subnet_id                       = "${azurerm_subnet.trust_subnet.id}"
        private_ip_address_allocation   = "dynamic"
    }
    
    depends_on = ["azurerm_network_interface.TRUST"]
}
resource "azurerm_virtual_machine" "RDS01" {
    name                            = "${var.rds01_name}"
    location                        = "${var.location}"
    resource_group_name             = "${azurerm_resource_group.rg.name}"
    network_interface_ids           = ["${azurerm_network_interface.RDS-NIC.id}"]
    vm_size                         = "Standard_F4s"

    storage_image_reference {
        publisher                               = "MicrosoftWindowsServer"
        offer                                   = "WindowsServer"
        sku                                     = "2016-Datacenter"
        version                                 = "latest"
    }

    storage_os_disk {
        name                                    = "${var.rds01_name}_OS"
        vhd_uri                                 = "${azurerm_storage_account.synapsysprd.primary_blob_endpoint}${azurerm_storage_container.vhds.name}/${var.rds01_name}_OS.vhd"
        caching                                 = "ReadWrite"
        create_option                           = "FromImage"
    }

    os_profile {
        computer_name   = "${var.rds01_name}"
        admin_username  = "${var.vm_username}"
        admin_password  = "${var.vm_password}"
    }

    os_profile_windows_config {

    }
}