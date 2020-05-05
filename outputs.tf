# This file contains outputs from the module
# https://www.terraform.io/docs/configuration/outputs.html

output "vpc_peering_connection_id" {
  description = "The ID of the VPC Peering Connection."
  value       = "${locals.vpc_peering_connection_id}"
}
