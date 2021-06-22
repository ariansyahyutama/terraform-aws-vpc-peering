# This file contains variables definition for the module
# https://www.terraform.io/docs/configuration/variables.html

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC in your own account"
}

variable "product_domain" {
  type        = string
  description = "Product domain that own these resources"
}

variable "environment" {
  type        = string
  description = "Environment the VPC peering belongs to (testing, staging, or production)"
}

variable "additional_tags" {
  type        = map
  description = "Additional tags to be added to the peering connection tag"
  default     = {}
}

variable "is_connection_accepted" {
  type        = string
  description = "Whether or not the connection is accepted"
  default     = true
}

variable "is_requester" {
  type        = string
  description = "Identifier to differentiate requester (true) and accepter (false)"
  default     = false
}

variable "accepter_account_alias" {
  type        = string
  description = "AWS Account alias of the accepter. This will be used in tag to help you easily identify the peering connection"
}

variable "requester_account_alias" {
  type        = string
  description = "AWS Account alias of the requester. This will be used in tag to help you easily identify the peering connection"
}

variable "destination_vpc_cidr_block" {
  type        = string
  description = "CIDR of the peer account's VPC"
}

variable "peer_account_id" {
  type        = string
  description = "The AWS account ID of the owner of the peer VPC. If you are accepter, you can provide empty string for this"
}

variable "peer_vpc_id" {
  type        = string
  description = "The ID of the VPC with which you are creating the VPC Peering connection. If you are accepter, you can provide empty string for this"
}

variable "peer_vpc_region" {
  type        = string
  description = "The region of the accepter VPC of the VPC Peering Connection. If you are accepter, you can provide empty string for this"
}

variable "vpc_peering_connection_id" {
  type        = string
  description = "The ID of VPC peering connection provided by requester. If you are requester, you can provide empty string for this"
}

variable "aws_route_tables_public_filter" {
  type        = list
  description = "Additional filter to match the existing public route table"
  default     = []
}

variable "aws_route_tables_app_filter" {
  type        = list
  description = "Additional filter to match the existing app route table"
  default     = []
}

variable "aws_route_tables_data_filter" {
  type        = list
  description = "Additional filter to match the existing data route table"
  default     = []
}
