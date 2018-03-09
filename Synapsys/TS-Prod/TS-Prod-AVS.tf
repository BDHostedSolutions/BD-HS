resource "azurerm_availability_set" "calinux-avs" {
    name                                        = "${var.calinux_avs_name}"
    location                                    = "${var.location}"
    resource_group_name                         = "${azurerm_resource_group.rg.name}"
    managed                                     = false
    
    tags {
        display_name                            = "AvailabilitySet"
      }
}

resource "azurerm_availability_set" "carrier-avs" {
    name                                        = "${var.carrier_avs_name}"
    location                                    = "${var.location}"
    resource_group_name                         = "${azurerm_resource_group.rg.name}"
    managed                                     = false

    tags {
        display_name                            = "AvailabilitySet"
      }
}

resource "azurerm_availability_set" "dns-avs" {
    name                                        = "${var.dns_avs_name}"
    location                                    = "${var.location}"
    resource_group_name                         = "${azurerm_resource_group.rg.name}"
    managed                                     = false

    tags {
        display_name                            = "AvailabilitySet"
      }
}

resource "azurerm_availability_set" "sapds-avs" {
    name                                        = "${var.sapds_avs_name}"
    location                                    = "${var.location}"
    resource_group_name                         = "${azurerm_resource_group.rg.name}"
    managed                                     = false

    tags {
        display_name                            = "AvailabilitySet"
      }
}

resource "azurerm_availability_set" "shavlik-avs" {
    name                                        = "${var.shavlik_avs_name}"
    location                                    = "${var.location}"
    resource_group_name                         = "${azurerm_resource_group.rg.name}"
    managed                                     = false

    tags {
        display_name                            = "AvailabilitySet"
      }
}

resource "azurerm_availability_set" "ssis-avs" {
    name                                        = "${var.ssis_avs_name}"
    location                                    = "${var.location}"
    resource_group_name                         = "${azurerm_resource_group.rg.name}"
    managed                                     = false

    tags {
        display_name                            = "AvailabilitySet"
      }
}

resource "azurerm_availability_set" "splunk-avs" {
    name                                        = "${var.splunk_avs_name}"
    location                                    = "${var.location}"
    resource_group_name                         = "${azurerm_resource_group.rg.name}"
    managed                                     = false

    tags {
        display_name                            = "AvailabilitySet"
      }
}