resource "azurerm_servicebus_namespace" "basic" {
  name                = "${var.servicebus_name}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  sku                 = "basic"
  capacity            = 1
}
