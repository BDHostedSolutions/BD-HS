#----networking/outputs.tf

output "demo_nsg" {
  value = "${azurerm_network_security_group.nsg_demo.id}"
}

output "demo_vnet" {
  value = "${azurerm_virtual_network.vnet.id}"
}

output "demo_subnet" {
  value = "${azurerm_subnet.demo_subnet.id}"
}
