resource "azurerm_sql_server" "ds_sql" {
  name                         = "${var.sql_rn_prefix}-${var.ds_sql_server_name}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  version                      = "12.0"
  administrator_login          = "${var.vm_username}"
  administrator_login_password = "${var.vm_password}"
}

resource "azurerm_sql_firewall_rule" "dsallowBDIps" {
  name                = "AllowBDIps"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  server_name         = "${azurerm_sql_server.ds_sql.name}"
  start_ip_address    = "63.241.111.230"
  end_ip_address      = "63.241.111.230"
}

resource "azurerm_sql_firewall_rule" "dsallowAllAzureIps" {
  name                = "AllowAllWindowsAzureIps"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  server_name         = "${azurerm_sql_server.ds_sql.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_database" "dsSQLDB" {
  name                             = "${var.resource_name_prefix}-${var.ds_sql_db_name}"
  resource_group_name              = "${azurerm_resource_group.rg.name}"
  location                         = "${var.location}"
  server_name                      = "${azurerm_sql_server.ds_sql.name}"
  collation                        = "${var.db_collation}"
  edition                          = "${var.db_edition}"
  max_size_bytes                   = "268435456000"
  requested_service_objective_name = "${var.db_rson}"
}

resource "azurerm_sql_server" "cis_sql" {
  name                         = "${var.sql_rn_prefix}-${var.cis_sql_server_name}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  version                      = "12.0"
  administrator_login          = "${var.vm_username}"
  administrator_login_password = "${var.vm_password}"
}

resource "azurerm_sql_firewall_rule" "cisallowBDIps" {
  name                = "AllowBDIps"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  server_name         = "${azurerm_sql_server.cis_sql.name}"
  start_ip_address    = "63.241.111.230"
  end_ip_address      = "63.241.111.230"
}

resource "azurerm_sql_firewall_rule" "cisallowAllAzureIps" {
  name                = "AllowAllWindowsAzureIps"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  server_name         = "${azurerm_sql_server.cis_sql.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_database" "cisSQLDB" {
  name                             = "${var.resource_name_prefix}-${var.cis_sql_db_name}"
  resource_group_name              = "${azurerm_resource_group.rg.name}"
  location                         = "${var.location}"
  server_name                      = "${azurerm_sql_server.cis_sql.name}"
  collation                        = "${var.db_collation}"
  edition                          = "${var.db_edition}"
  max_size_bytes                   = "268435456000"
  requested_service_objective_name = "${var.db_rson}"
}