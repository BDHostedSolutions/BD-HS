
/* Configure Azure Provider and declare all the Variables that will be used in Terraform configurations */
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id = "${var.client_id}"
  client_secret = "${var.client_secret}"
  tenant_id = "${var.tenant_id}"
}

variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
}

variable "client_id" {
  description = "Enter Client ID"
}

variable "client_secret" {
  description = "Enter Client secret"
}

variable "tenant_id" {
  description = "Enter Tenant ID"
}

variable "location" {
  description = "The default Azure region for the resource provisioning"
}

variable "shared_resource_group_name" {
  description = "The name of the shared resource group"
}

variable "vm_resource_group_name" {
  description = "The name of the vm resource group"
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
}

variable "dns_servers" {
  description = "The DNS servers to be used with vNet"
}

variable "mgmt_subnet" {
  description = "The address prefix to use for the mgmt subnet."
}

variable "untrust_subnet" {
  description = "The address prefix to use for the untrust subnet."
}

variable "trust_subnet" {
  description = "The address prefix to use for the trust subnet."
}

variable "dmz_subnet" {
  description = "The address prefix to use for the dmz subnet."
}

variable "appgw_subnet" {
  description = "The address prefix to use for the appgw subnet."
}

variable "subnet_name_prefix" {
  description = "Subnet prefix for subnet names."
  default     = "sn-"
}

variable "nsg_name_prefix" {
  description = "Prefix for nsg names."
  default     = "nsg_"
}

variable "firewall_name" {
  description = "The name of the firewall"
  default     = "PCCA-HSFW00"
}

variable "kpfile01_name" {
  description = "The name of the new KPFILE01 VM"
  default     = "PCCA-KPFILE01"
}

variable "kpapp01_name" {
  description = "The name of the new KPAPP01 VM"
  default     = "PCCA-KPAPP01"
}

variable "kpidb01_name" {
  description = "The name of the new KPIDB01 VM"
  default     = "PCCA-KPIDB01"
}

variable "kpidmcor01_name" {
  description = "The name of the new KPIDMCOR01 VM"
  default     = "PCCA-KPIDMCOR01"
}

variable "kpmdb01_name" {
  description = "The name of the new KPMDB01 VM"
  default     = "PCCA-KPMDB01"
}

variable "kprds01_name" {
  description = "The name of the new KPRDS01 VM"
  default     = "PCCA-KPRDS01"
}

variable "kprpt01_name" {
  description = "The name of the new KPRPT01 VM"
  default     = "PCCA-KPRPT01"
}

variable "kpweb01_name" {
  description = "The name of the new KPWEB01 VM"
  default     = "PCCA-KPWEB01"
}

variable "kpweb02_name" {
  description = "The name of the new KPWEB02 VM"
  default     = "PCCA-KPWEB02"
}

variable "fw_username" {
  description = "The username for the firewall"
}

variable "fw_password" {
  description = "The password for the firewall"
}

variable "ILB_name" {
  description = "The internal load balancer name"
  default     = "BD-ILB"
}

variable "AppGw_name" {
  description = "The application gateway name"
  default     = "BD-AppGw"
}

variable "ssl_data" {
  description = "Base64 version of .pfx file"
}

variable "ssl_password" {
  description = "SSL certificate password"
}

variable "auth_cert_data" {
  description = "Base64 version of .cer file"
}

variable "vm_username" {
  description = "Enter local admin username for VMs"
}

variable "vm_password" {
  description = "Ender local admin password for VMs"
}