# This file contains data resources only
# https://www.terraform.io/docs/configuration/data-sources.html

data "aws_route_tables" "public" {
  vpc_id = "${var.vpc_id}"

  tags {
    Tier = "public"
  }
}

data "aws_route_tables" "app" {
  vpc_id = "${var.vpc_id}"

  tags {
    Tier = "app"
  }
}

data "aws_route_tables" "data" {
  vpc_id = "${var.vpc_id}"

  tags {
    Tier = "data"
  }
}
