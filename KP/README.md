# Terraform

Text here is not applicable to this repository and will be updated as time permits. It is just a placeholder.

This project uses a Packer template to provision a prebaked AMI containing the Apache web server based off of Amazon Linux. The AMI is then passed to a CloudFormation template as a parameter value. The CloudFormation template creates the following infrastructure resources:

* VPC
* Internet Gateway
* Route Table Entries
* Public Subnet
* NACL with ingress ports 22,80,443 open, as well as ephemeral ports for updates and curl to work.
* EC2 Instance based off of the Packer AMI that is bootstrapped to provide all updates, set the httpd service to start on boot, and copies over a preconfigured index.html file from S3.
* EC2 Security Group allowing ports 22,80,443. 

Finally, CloudFormation outputs the Public URL to access the website.

## Requirements

* Packer 1.1.2
* AWS CLI 1.12.1
* Bash

## Deployment

The following commands were used:

* First, create the prebaked AMI using the Packer template:
    * `packer build challenge.packer`
* Next, grab the Image ID of the created AMI and pass it into CloudFormation as a parameter.
	* `aws cloudformation create-stack --stack-name DemystData \`
	* `--template-body file://CF-Challenge.json \`
	* `--parameters ParameterKey=PackerAMI,ParameterValue=*packer image id* \`
	* `ParameterKey=DemystKeyPair,ParameterValue=*valid key pair*`
## Files

* `./CF-Challenge.json` CloudFormation template.
* `./challenge.packer` Packer template.
* `./Scripts/apache.sh` Bash script to install and configure Apache.
* `https://s3.amazonaws.com/demystdata-challenge/index.html` Preconfigured HTML page stored on S3.

## Output
