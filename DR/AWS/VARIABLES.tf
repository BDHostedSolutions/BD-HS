/* Configure AWS Provider and declare all the Variables that will be used in Terraform configurations */
provider "aws" {
  version     = "~> 1.24"
  access_key  = "${var.aws_access_key}"
  secret_key  = "${var.aws_secret_key}"
  region      = "${var.region}"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}
variable "address_space" {}

variable "dns_servers" {}

variable "mgmt_subnet" {}
variable "untrust_subnet" {}
variable "trust_subnet" {}
variable "dmz_subnet" {}
variable "mm_subnet" {}
variable "hs_subnet" {}
variable "fw_username" {}
variable "fw_password" {
}

