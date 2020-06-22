# terraform-aws-vpc-peering

[![Terraform Version](https://img.shields.io/badge/Terraform%20Version->=0.11.14,_<0.12.0-blue.svg)](https://releases.hashicorp.com/terraform/)
[![Release](https://img.shields.io/github/release/traveloka/terraform-aws-vpc-peering.svg)](https://github.com/traveloka/terraform-aws-vpc-peering/releases)
[![Last Commit](https://img.shields.io/github/last-commit/traveloka/terraform-aws-vpc-peering.svg)](https://github.com/traveloka/terraform-aws-vpc-peering/commits/master)
[![Issues](https://img.shields.io/github/issues/traveloka/terraform-aws-vpc-peering.svg)](https://github.com/traveloka/terraform-aws-vpc-peering/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/traveloka/terraform-aws-vpc-peering.svg)](https://github.com/traveloka/terraform-aws-vpc-peering/pulls)
[![License](https://img.shields.io/github/license/traveloka/terraform-aws-vpc-peering.svg)](https://github.com/traveloka/terraform-aws-vpc-peering/blob/master/LICENSE)
![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.png?v=103)

## Table of Content

- [Prerequisites](#Prerequisites)
- [Dependencies](#Dependencies)
- [Quick Start](#Quick-Start)
- [Versioning](#Versioning)
- [Contributing](#Contributing)
- [Authors](#Authors)
- [License](#License)

## Prerequisites

- [Terraform](https://releases.hashicorp.com/terraform/). This module currently tested on `0.11.14`

## Dependencies

- TODO

## Quick Start

Terraform module to create VPC peering components for requester and accepter

### Example
* [VPC Peering requester-side](https://github.com/traveloka/terraform-aws-vpc-peering/tree/master/examples/requester)
* [VPC Peering accepter-side](https://github.com/traveloka/terraform-aws-vpc-peering/tree/master/examples/accepter)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### Importing Existing VPC peering Configuration
There's 2 way to import existing VPC peering configuration to Terraform module state, manual import or using script that we provided `import.sh`

Initiate the Terraform module block for both requester and accepter side, this is an example

##### Requester
```
module "vpc_peering_requester" {
  source = "git@github.com:traveloka/terraform-aws-vpc-peering.git?ref=v1.0.1" #latest module version this document created

  product_domain = "{pd}"
  environment    = "{environment}"

  is_requester               = "true"
  vpc_id                     = "{requester vpc id}"
  accepter_account_alias     = "{accepter account alias}"
  requester_account_alias    = "{requester account alias}"
  vpc_peering_connection_id  = "" # leave this empty for this step
  destination_vpc_cidr_block = "{accepter vpc cidr block}"
  peer_account_id            = "{accepter account id}"
  peer_vpc_id                = "{accepter vpc id}"
  peer_vpc_region            = "{accepter vpc region}"

  is_connection_accepted = "false" # set this as false in this step
}
```

##### Accepter
```
module "vpc_peering_accepter" {
  source = "git@github.com:traveloka/terraform-aws-vpc-peering.git?ref=v1.0.1" #latest module version this document created

  product_domain = "{pd}"
  environment    = "{environment}"

  is_requester               = "false"
  vpc_id                     = "{accepter vpc id}"
  accepter_account_alias     = "{accepter account alias}"
  requester_account_alias    = "{requester account alias}"
  vpc_peering_connection_id  = "{vpc peering connection id}"
  destination_vpc_cidr_block = "{requester vpc cidr block}"
  peer_account_id            = "{requester account id}"
  peer_vpc_id                = "{requester vpc id}"
  peer_vpc_region            = "{requester vpc region}"

  is_connection_accepted = "true"

  aws_route_tables_public_filter = [
    {
      name   = "tag:Name"
      values = ["prod-pub-rtb"]
    },
  ]

  aws_route_tables_app_filter = [
    {
      name   = "tag:Name"
      values = ["prod-app-rtb-*"]
    },
  ]
}
```

#### Using Script `import.sh`
Update the `import.sh` file permission to an executable file
```shell script
chmod +x import.sh
```
For both requester and accepter side run below command
```shell script
./import.sh
```
The script will ask
* VPC peering id
* Module name (the Terraform module resource name)
* Is requester (y/n) 

The script will help you to import existing configuration based on `terraform plan` result, this is reduce the infrastructure changes due to difference sequence of Terraform module state result which might causes `force new resource` creation

> **Tips!** You might need to do a `terraform plan` and adjust the terraform configuration until there's **no infrastructure changes** while importing the state 

#### Manual Import
To manually import the configuration to the Terraform module state you need to make sure the sequence of list type of resources must be the same with `terraform plan` result, otherwise the difference sequence of Terraform state might cause `force new resource` creation, which will break your existing configuration

Import `vpc_peering_connection` resource by changing the **<vpc_peering_id>** to existing VPC peering connection id and **<terraform_module_name>** to a Terraform module resource name
```shell script
terraform import module.<terraform_module_name>.aws_vpc_peering_connection.connection <vpc_peering_id>

# if requester, run below command too
terraform import module.<terraform_module_name>.aws_vpc_peering_connection_options.requester <vpc_peering_id> 
```
Import `aws_route` resource, because of this resource is a list type of resources, we need to do a `terraform plan` first to make sure we follow the sequence of import to make sure we are resulting in no infrastructure changes while terraform plan
```shell script
terraform plan
```
The result of terraform plan may look like this
```shell script
------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
+ create

Terraform will perform the following actions:

+ module.vpc_peering_requester.aws_route.route_table_app[0]
destination_cidr_block: "172.20.0.0/16"
route_table_id: "rtb-someid-01"

+ module.vpc_peering_requester.aws_route.route_table_app[1]
destination_cidr_block: "172.20.0.0/16"
route_table_id: "rtb-someid-02"

+ module.vpc_peering_requester.aws_route.route_table_data[0]
destination_cidr_block: "172.20.0.0/16"
route_table_id: "rtb-someid-03"

+ module.vpc_peering_requester.aws_route.route_table_data[1]
destination_cidr_block: "172.20.0.0/16"
route_table_id: "rtb-someid-04"

+ module.vpc_peering_requester.aws_route.route_table_public
destination_cidr_block: "172.20.0.0/16"
route_table_id: "rtb-someid-05"

Plan: 5 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------
```
You need to do a terraform import based on the sequence of the terraform plan result list, here is an example of the terraform import sequence based on above terraform plan result
```shell script
terraform import module.vpc_peering_requester.aws_route.route_table_app[0] rtb-someid-01_172.20.0.0/16
terraform import module.vpc_peering_requester.aws_route.route_table_app[1] rtb-someid-02_172.20.0.0/16
terraform import module.vpc_peering_requester.aws_route.route_table_data[0] rtb-someid-03_172.20.0.0/16
terraform import module.vpc_peering_requester.aws_route.route_table_data[1] rtb-someid-04_172.20.0.0/16
terraform import module.vpc_peering_requester.aws_route.route_table_public rtb-someid-05_172.20.0.0/16
```

> **Tips!** You might need to do a `terraform plan` and adjust the terraform configuration until there's **no infrastructure changes** while importing the state 

## Versioning

Please see our [CHANGELOG.md](./CHANGELOG.md) for full details.

## Contributing

Contributions are welcomed! See [CONTRIBUTING.md](./CONTRIBUTING.md) for full details.

## Authors

- [Febry Antonius](https://github.com/febryantonius)

## License

Apache 2 Licensed. See [LICENSE](./LICENSE) for full details.
