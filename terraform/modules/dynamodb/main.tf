# Local variables
locals {
  module = "dynamodb"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

resource "aws_dynamodb_table" "dynamodb_table_photos" {
  name = "${format("%s-photos", local.name)}"
  tags = "${local.tags}"

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "Nickname"
  range_key = "thumb"

  attribute = [{
    name = "Nickname"
    type = "S"
  }, {
    name = "Thumb"
    type = "S"
  }, {
    name = "Photo"
    type = "S"
  }]
}

resource "aws_dynamodb_table" "dynamodb_table_taged" {
  name = "${format("%s-photos", local.name)}"
  tags = "${local.tags}"

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "Tag"
  range_key = "Thumb"

  attribute = [{
    name = "Tag"
    type = "S"
  }, {
    name = "Thumb"
    type = "S"
  }]
}

resource "aws_dynamodb_table" "dynamodb_table_tags" {
  name = "${format("%s-photos", local.name)}"
  tags = "${local.tags}"

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "Tag"
  range_key = "Score"

  attribute = [{
    name = "Tag"
    type = "S"
  }, {
    name = "Score"
    type = "N"
  }]
}
