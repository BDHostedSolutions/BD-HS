resource "azurerm_resource_group" "network" {
  name     = "module-rg"
  location = "eastus"
}

module "network" {
  source                = "Azure/network/azurerm"
  version               = "2.0.0"
  vnet_name             = "mod-vnet"
  resource_group_name   = "module-rg"
  location              = "eastus"
  address_space         = "10.0.0.0/16"
  subnet_prefixes       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names          = ["subnet1", "subnet2", "subnet3"]
  tags                  = {
                            environment = "dev"
                            costcenter  = "it"
                          }
}