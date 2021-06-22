# This file contains data resources only
# https://www.terraform.io/docs/configuration/data-sources.html

data "aws_route_tables" "public" {
  vpc_id = var.vpc_id

  tags = {
    Tier = "public"
  }

  dynamic "filter" {
    for_each = var.aws_route_tables_public_filter
    content {
      name   = setting.value["name"]
      values = setting.value["values"]
    }

  }
}

data "aws_route_tables" "app" {
  vpc_id = var.vpc_id

  tags = {
    Tier = "app"
  }

  dynamic "filter" {
    for_each = var.aws_route_tables_app_filter
    content {
      name   = setting.value["name"]
      values = setting.value["values"]
    }

  }
}

data "aws_route_tables" "data" {
  vpc_id = var.vpc_id

  tags = {
    Tier = "data"
  }

  dynamic "filter" {
    for_each = var.aws_route_tables_data_filter
    content {
      name   = setting.value["name"]
      values = setting.value["values"]
    }

  }
}
