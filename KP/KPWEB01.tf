data "azurerm_image" "KPWEB01-Image" {
    name = "CustomImage"
    resource_group_name = "shared"
}

resource "azurerm_availability_set" "WEBAVS" {
    name                            = "AVS-CC-KP-WEB"
    location                        = "${var.location}"
    resource_group_name             = "${azurerm_resource_group.vmrg.name}"
    managed                         = "true"
    platform_update_domain_count    = "5"
    platform_fault_domain_count     = "2"
}

resource "azurerm_network_interface" "KPWEB01-NIC" {
    name                        = "${var.kpweb01_name}-eth0"
    location                    = "${var.location}"
    resource_group_name         = "${azurerm_resource_group.vmrg.name}"
    network_security_group_id   = "${azurerm_network_security_group.nsg_DMZ.id}"

    ip_configuration {
        name                            = "KPWEB01"
        subnet_id                       = "${azurerm_subnet.dmz_subnet.id}"
        private_ip_address_allocation   = "dynamic"
    }
    
    depends_on = ["azurerm_network_interface.DMZ"]
}
resource "azurerm_virtual_machine" "KPWEB01" {
    name                            = "${var.kpweb01_name}"
    location                        = "${var.location}"
    resource_group_name             = "${azurerm_resource_group.vmrg.name}"
    network_interface_ids           = ["${azurerm_network_interface.KPWEB01-NIC.id}"]
    availability_set_id             = "${azurerm_availability_set.WEBAVS.id}"
    vm_size                         = "Standard_F4s"

    storage_image_reference {
        id          = "${data.azurerm_image.KPWEB01-Image.id}"
    }

    storage_os_disk {
        name                = "${var.kpweb01_name}_OS"
        caching             = "ReadWrite"
        create_option       = "FromImage"
        managed_disk_type   = "Standard_LRS"
    }

    os_profile {
        computer_name   = "${var.kpweb01_name}"
        admin_username  = "${var.vm_username}"
        admin_password  = "${var.vm_password}"
    }

    os_profile_windows_config {

    }
}