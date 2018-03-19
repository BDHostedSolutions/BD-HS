resource "azurerm_servicebus_namespace" "basic" {
  name                = "${var.resource_name_prefix}-${var.servicebus_name}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  sku                 = "basic"
}
