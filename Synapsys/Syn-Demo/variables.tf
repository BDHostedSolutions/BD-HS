#----root/variables.tf

variable "env" {
    description = "Location of Demo Environment. US, EU, CA, AP"
}
variable "subscription_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "tenant_id" {}

variable "resource_group_name" {
    type = "map"
}

variable "location" {
    type = "map"
}

variable "demovm_size" {}

variable "vm_username" {}
variable "vm_password" {}
variable "demovm_name" {
    type = "map"
}
variable "demo_subnet" {}

variable "vnet_name" {
    type = "map"
}
variable "address_space" {}

variable "demo_nsg_name" {}