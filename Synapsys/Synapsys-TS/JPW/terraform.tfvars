# 'BDDS - InfoStratus' Service Principal/Subscription Info
subscription_id                 = "3b1cc931-8a08-4dfe-8e09-d456b4a1b4a0"
client_id                       = "2d67dc5a-01b3-4d50-b020-44a007f292fb"
client_secret                   = "796f2b72-1a20-4a05-8bce-a0467308ac66"
tenant_id                       = "94c3e67c-9e2d-4800-a6b7-635d97882165"

# Azure Region
location                        = "japanwest"

# Name prefix based off Azure Naming Convention (Will be appended
# to all resource names below)
resource_name_prefix            = "PCJPW"
sql_rn_prefix                   = "pcjpw"

# Azure Resource Group
resource_group_name             = "BDDS-Synapsys-JPW-Prod"

# VNet Name and Address Space
vnet_name                       = "Synapsys-JPW-Prod-VNet"
address_space                   = "172.16.208.0/20"

# VNet Subnets
mgmt_subnet                     = "172.16.208.0/24"
untrust_subnet                  = "172.16.209.0/24"
trust_subnet                    = "172.16.210.0/24"
hosted_subnet                   = "172.16.211.0/24"
syn_dmz_subnet                  = "172.16.212.0/24"
syn_data_subnet                 = "172.16.213.0/24"
ts_dmz_subnet                   = "172.16.214.0/24"
appgw_subnet                    = "172.16.215.0/24"

# Key Vault Name
keyvault_name                   = "TSFLVault-JPW-Prod"

# DNS Servers (Global is Azure's DNS)
#dns_server                      = "172.16.130.11"
#global_dns_server               = "10.219.55.10"
dns_server                      = "10.219.55.10"
global_dns_server               = "168.63.129.16"

# BD IPs for NSGs
bdips                           = "63.241.111.230/32"
bdips1                          = "63.106.106.2/32"
bdips2                          = "73.37.171.52/32"
bdips3                          = "72.37.244.100/32"

# Azure Storage Accounts (Names must be globally unique. Each will be prepended with the resource_name_prefix value above)
storage_acct_name               = "synpasysprd001"
db_storage_acct_name            = "synapsysdbprd001"
veritor_storage_acct_name       = "veritorimagesprd001"
etl_storage_acct_name           = "etlfiles001"
etl_backup_storage_acct_name    = "etlfilesbackup001"
etl_db_backup_storage_acct_name = "etldbbackup001"

# Load Balancer and Application Gateway
lb_name                         = "SYN-LB"
ts_prod_ilb_name                = "TS-PROD-LB"
appgw_name                      = "SYN-AGW"

# Application Servers/Availability Set Names
app_server_avs_name             = "App-AS"
appvm0_name                     = "App-VM0"
appvm1_name                     = "App-VM1"
app_vm_size                     = "Standard_DS3_v2"

# Database Server/Availability Set Names
db_server_avs_name              = "SQL-AS"
dbvm_name                       = "SQL-VM0"
sql_vm_size                     = "Standard_DS3_v2"

# RDS Server/Availability Set Names
rds_server_avs_name             = "RDS-AS"
rdsvm_name                      = "SYNRDS01"
rds_vm_size                     = "Standard_D2s_v3"

# Carrier Server/Availability Set Names
ts-services_avs_name            = "TS-Services-AS"
ts-servicesvm0_name             = "TS-SERV0"
ts-servicesvm1_name             = "TS-SERV1"
ts-services_vm_size             = "Standard_D2s_v3"

# Azure SQL Resources
cis_sql_server_name             = "carrierservices"
cis_sql_db_name                 = "CarrierIntegration"
ds_sql_server_name              = "dataservices"
ds_sql_db_name                  = "CustomerMaster"
db_rson                         = "S3"
db_collation                    = "SQL_Latin1_General_CP1_CI_AS"
db_edition                      = "Standard"

# DC Server Name
dcvm0_name                      = "SYNDC01"
dc_vm_size                      = "Standard_D2s_v3"

# Local Admin User/Pass
vm_username                     = "bdiadmin"
vm_password                     = ""

# Firewall Server/Availability Set Names
fw_avs_name                     = "FW-AVSet"
firewall_name                   = "SYNFW01"
fw_vm_size                      = "Standard_D3_v2"

# FW Admin User/Pass
fw_username                     = "hsopsadmin"
fw_password                     = ""

# Service Bus
servicebus_name                 = "ServiceBus"
