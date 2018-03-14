# BD Azure Terraform Files

Repository to hold Terraform projects related to BD in Azure.

* DR
* KP
* Synapsys
* MedMined

## Requirements

* Terraform
* Azure Subscription
* TFVARS file

## Deployment

Run the following commands from a CLI terminal inside the relevant directory.

* `terraform init`  Run once the first time from a new directory.
* `terraform plan`  Shows you the changes that will be applied.
* `terraform apply` Applies the changes to the environment.

## Subdirectories

* `/Synapsys/Synapsys-Hosted` Integrated Hybrid Infrastructure w/ Syapsys + HS Architecture.
* `/Synapsys/Synapsys` Full Synapsys/Infostratus Infrastructure.
* `/Scripts/TS-Prod` Full TS Production Infrastructure.
* `/Scripts/TS-Staging` Full TS Staging Infrastructure.

## Terraform Azure Documentation

* [Terraform Azure](https://www.terraform.io/docs/providers/azurerm/index.html)