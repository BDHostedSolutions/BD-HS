#----compute/main.tf

data "azurerm_image" "demo-image" {
  name                = "DEMO-VM1-image"
  resource_group_name = "${var.rg_name}"
}

resource "azurerm_public_ip" "demo-pip" {
  name                         = "DEMO-VM0-pip"
  location                     = "${var.rg_location}"
  resource_group_name          = "${var.rg_name}"
  public_ip_address_allocation = "Dynamic"
  domain_name_label            = "${var.domain_name}"
  
}
resource "azurerm_network_interface" "demovm-nic" {
  name                = "${var.demovm_name}-nic0"
  location            = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"

  ip_configuration {
    name                                    = "ipconfig1"
    subnet_id                               = "${var.demo_subnet}"
    private_ip_address_allocation           = "dynamic"
    public_ip_address_id                    = "${azurerm_public_ip.demo-pip.id}"
  }
}

resource "azurerm_virtual_machine" "demovm" {
  name                  = "${var.demovm_name}"
  location              = "${var.rg_location}"
  resource_group_name   = "${var.rg_name}"
  network_interface_ids = ["${azurerm_network_interface.demovm-nic.id}"]
  vm_size               = "${var.demovm_size}"
  license_type          = "Windows_Server"

  storage_image_reference {
    id = "${data.azurerm_image.demo-image.id}"
  }

  storage_os_disk {
    name              = "${var.demovm_name}_OS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.demovm_name}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

resource "azurerm_virtual_machine_extension" "demovm_iaasantimalware" {
  name                       = "${var.demovm_name}-IaaSAntimalware"
  location                   = "${var.rg_location}"
  resource_group_name        = "${var.rg_name}"
  virtual_machine_name       = "${azurerm_virtual_machine.demovm.name}"
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.5"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "AntimalwareEnabled": "true",
        "ScheduledScanSettings": {
            "isEnabled": "true",
            "scanType": "Quick",
            "day": "7",
            "time": "120"
        },
        "Exclusions": {
            "Paths": "C:\\Users",
            "Extensions": ".txt",
            "Processes": "taskmgr.exe"
        },
        "RealtimeProtectionEnabled": "true"
    }
  SETTINGS

  depends_on = ["azurerm_virtual_machine.demovm"]
}