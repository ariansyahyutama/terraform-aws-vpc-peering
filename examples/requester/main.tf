# This file contains terraform version constrains, provider definition, and also main resources.
# https://www.terraform.io/docs/configuration/resources.html

terraform {
  required_version = ">= 0.11.14, < 0.12.0"
}

provider "aws" {
  version = ">= 2.0.0, < 3.0.0"
  region  = "ap-southeast-1"
}

module "vpc_peering_requester" {
  source = "../../"

  product_domain = "bei"
  environment    = "testing"

  is_requester               = "true"
  vpc_id                     = "vpc-1234a5f6e7d8c9b0a"
  accepter_account_alias     = "tvlk-tsi-dev"
  requester_account_alias    = "tvlk-bei-dev"
  vpc_peering_connection_id  = ""
  destination_vpc_cidr_block = "192.164.0.0/16"
  peer_account_id            = "285292138376"
  peer_vpc_id                = "vpc-01c234ebd567af890"
  peer_vpc_region            = "ap-southeast-1"

  is_connection_accepted = "false" # change this to true after the connection is accepted by accepter and do terraform apply again
}
