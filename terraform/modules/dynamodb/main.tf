# Local variables
locals {
  module = "dynamodb"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name = "${local.name}"
  tags = "${local.tags}"

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "nickname"
  range_key = "id"

  attribute = [{
    name = "nickname"
    type = "S"
  }, {
    name = "id"
    type = "S"
  }]
}
