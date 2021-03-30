# This file contains terraform version constrains, provider definition, and also main resources.
# https://www.terraform.io/docs/configuration/resources.html

terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = "~> 3.0.0"
  region  = "ap-southeast-1"
}

module "vpc_peering_accepter" {
  source = "../../"

  product_domain = "tsi"
  environment    = "testing"

  is_requester               = false
  vpc_id                     = "vpc-1a2b3c4d5e6f7g8h9i"
  accepter_account_alias     = "aws-accepter"
  requester_account_alias    = "aws-requester"
  vpc_peering_connection_id  = "pcx-1a2b3c4d5e6f7g8h9i"
  destination_vpc_cidr_block = "192.166.0.0/16"
  peer_account_id            = "12345678913"
  peer_vpc_id                = "vpc-2a2b3c4d5e6f7g8h9i"
  peer_vpc_region            = "ap-southeast-1"

  is_connection_accepted = true
}
