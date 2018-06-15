resource "azurerm_app_service_plan" "SynapsysTS" {
    name    = "${var.resource_name_prefix}-TSProd"
    location = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"

    sku {
        tier    = "Standard"
        size    = "S1"
    }
}

resource "azurerm_app_service" "CarrierPurge" {
    name = "${var.sql_rn_prefix}-carrierpurgeproduction"
    location    = "${azurerm_resource_group.rg.location}"
    resource_group_name = "${azurerm_resource_group.rg.name}"
    app_service_plan_id  = "${azurerm_app_service_plan.SynapsysTS.id}"

    site_config {
        dotnet_framework_version    = "v4.0"
        php_version                 = "5.6"
        use_32_bit_worker_process   = "True"
        always_on                   = "True"
        default_documents           = [
            "Default.htm",
            "Default.html",
            "Default.asp",
            "index.htm",
            "index.html",
            "iisstart.htm",
            "default.aspx",
            "index.php",
            "hostingstart.html"
        ]
    }

    app_settings {
        "WEBSITE_NODE_DEFAULT_VERSION" = "4.2.3"
    }
}