resource "azurerm_availability_set" "app-server-avs" {
  name                = "${var.app_server_avs_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  managed             = false

  tags {
    display_name = "AvailabilitySet"
  }
}

resource "azurerm_public_ip" "App_pip" {
  name                         = "App-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    display_name = "Public IP"
  }
}

resource "azurerm_network_interface" "app-vm0-nic" {
  name                      = "${var.resource_name_prefix}-${var.appvm0_name}-eth0"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg_App1.id}"

  tags {
    display_name = "NetworkInterface"
  }

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = "${azurerm_subnet.trust_subnet.id}"
    private_ip_address_allocation           = "dynamic"
    load_balancer_backend_address_pools_ids = ["${azurerm_lb_backend_address_pool.ilb_bep.id}"]
    load_balancer_inbound_nat_rules_ids     = ["${azurerm_lb_nat_rule.rdp0.id}"]
  }
}

resource "azurerm_virtual_machine" "app-vm0" {
  name                  = "${var.resource_name_prefix}-${var.appvm0_name}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.app-vm0-nic.id}"]
  availability_set_id   = "${azurerm_availability_set.app-server-avs.id}"
  vm_size               = "Standard_A3"

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
