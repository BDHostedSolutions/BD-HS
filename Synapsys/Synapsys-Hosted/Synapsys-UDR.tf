resource "azurerm_route_table" "trust_route_table" {
    name                = "trust_route_table"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    route {
        name = "default-route"
        address_prefix          = "0.0.0.0/0"
        next_hop_type           = "VirtualAppliance"
        next_hop_in_ip_address  = "10.3.2.4"
    }
    route {
        name = "trust-to-las-42-43"
        address_prefix          = "10.219.42.0/23"
        next_hop_type           = "VirtualAppliance"
        next_hop_in_ip_address  = "10.3.2.4"
    }
    route {
        name = "trust-to-las-46-47"
        address_prefix          = "10.219.46.0/23"
        next_hop_type           = "VirtualAppliance"
        next_hop_in_ip_address  = "10.3.2.4"
    }
    route {
        name = "trust-to-las-55"
        address_prefix          = "10.219.55.0/24"
        next_hop_type           = "VirtualAppliance"
        next_hop_in_ip_address  = "10.3.2.4"
    }
}