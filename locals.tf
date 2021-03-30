locals {
  allow_dns_resolution          = "true"
  allow_classic_link_connection = "false"

  # this is the workaround to handle the issue with the interpolation value of resource that have count 0
  vpc_peering_connection_id_temp = concat(aws_vpc_peering_connection.connection.*.id, list("${var.vpc_peering_connection_id}"))
  vpc_peering_connection_id      = element(local.vpc_peering_connection_id_temp, 0)
}
