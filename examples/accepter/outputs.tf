# This file contains outputs from the example
# https://www.terraform.io/docs/configuration/outputs.html

output "vpc_peering_connection_id" {
  description = "The ID of the VPC Peering Connection."
  value       = "${module.vpc_peering_to_requester.vpc_peering_connection_id}"
}
