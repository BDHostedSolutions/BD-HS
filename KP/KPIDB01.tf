data "azurerm_image" "KPIDB01-Image" {
    name = "CustomImage"
    resource_group_name = "shared"
}

resource "azurerm_availability_set" "IDBAVS" {
    name                = "AVS-CC-KP-DB-INF"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.vmrg.name}"
    managed             = "true"
    platform_update_domain_count    = "5"
    platform_fault_domain_count     = "2"
}

resource "azurerm_network_interface" "KPIDB-NIC" {
    name                        = "${var.kpidb01_name}-eth0"
    location                    = "${var.location}"
    resource_group_name         = "${azurerm_resource_group.vmrg.name}"
    network_security_group_id   = "${azurerm_network_security_group.nsg_TRUST.id}"

    ip_configuration {
        name                            = "KPIDB"
        subnet_id                       = "${azurerm_subnet.trust_subnet.id}"
        private_ip_address_allocation   = "dynamic"
    }
    
    depends_on = ["azurerm_network_interface.TRUST"]
}
resource "azurerm_virtual_machine" "KPIDB01" {
    name                            = "${var.kpidb01_name}"
    location                        = "${var.location}"
    resource_group_name             = "${azurerm_resource_group.vmrg.name}"
    network_interface_ids           = ["${azurerm_network_interface.KPIDB-NIC.id}"]
    availability_set_id             = "${azurerm_availability_set.IDBAVS.id}"
    vm_size                         = "Standard_F4s"

    storage_image_reference {
        id          = "${data.azurerm_image.KPIDB01-Image.id}"
    }

    storage_os_disk {
        name                = "${var.kpidb01_name}_OS"
        caching             = "ReadWrite"
        create_option       = "FromImage"
        managed_disk_type   = "Standard_LRS"
    }

    os_profile {
        computer_name   = "${var.kpidb01_name}"
        admin_username  = "${var.vm_username}"
        admin_password  = "${var.vm_password}"
    }

    os_profile_windows_config {

    }
}