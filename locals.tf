locals {
  allow_dns_resolution          = "true"
  allow_classic_link_connection = "false"
  vpc_peering_connection_id     = "${var.is_requester ? aws_vpc_peering_connection.connection.id : var.vpc_peering_connection_id}"
}
