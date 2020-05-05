# This file contains terraform version constrains, provider definition, and also main resources.
# https://www.terraform.io/docs/configuration/resources.html

terraform {
  required_version = ">= 0.11.14"
}

provider "aws" {
  version = ">= 2.0.0, < 3.0.0"
  region  = "ap-southeast-1"
}

module "vpc_peering_to_requester" {
  source = "../../"

  product_domain = "tsi"
  environment    = "testing"

  is_requester               = "false"
  vpc_id                     = ""
  accepter_account_alias     = "tvlk-tsi-dev"
  requester_account_alias    = "tvlk-bei-dev"
  vpc_peering_connection_id  = "pcx-1a2b3c4d5e6f7a890"
  destination_vpc_cidr_block = "192.166.0.0/16"
  peer_account_id            = ""
  peer_vpc_id                = ""
  peer_vpc_region            = ""

  is_connection_accepted = "true"
}
