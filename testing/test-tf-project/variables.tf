variable "subscription_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "tenant_id" {}

variable "resource_group_name" {
    default = "MOD-TEST"
}

variable "location" {
    default = "eastus"
}

variable "lb_name" {
    default = "MOD-ILB"
}

variable "fw_password" {}