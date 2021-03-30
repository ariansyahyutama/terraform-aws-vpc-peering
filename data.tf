# This file contains data resources only
# https://www.terraform.io/docs/configuration/data-sources.html

data "aws_route_tables" "public" {
  vpc_id = var.vpc_id

  tags {
    Tier = "public"
  }

  filter = var.aws_route_tables_public_filter
}

data "aws_route_tables" "app" {
  vpc_id = var.vpc_id

  tags {
    Tier = "app"
  }

  filter = var.aws_route_tables_app_filter
}

data "aws_route_tables" "data" {
  vpc_id = var.vpc_id

  tags {
    Tier = "data"
  }

  filter = var.aws_route_tables_data_filter
}
