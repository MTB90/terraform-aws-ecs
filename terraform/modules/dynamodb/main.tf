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

  hash_key  = "nickname"
  range_key = "thumb"

  attribute = [
    {
      name = "nickname"
      type = "S"
    },
    {
      name = "thumb"
      type = "S"
    },
    {
      name = "tag"
      type = "S"
    },
    {
      name = "likes"
      type = "N"
    },
  ]

  global_secondary_index {
    name            = "photo-tags"
    hash_key        = "tag"
    range_key       = "likes"
    projection_type = "ALL"
  }
}

resource "aws_dynamodb_table" "dynamodb_table_tags" {
  name = "${format("%s-tags", local.name)}"
  tags = "${local.tags}"

  billing_mode = "PAY_PER_REQUEST"
  hash_key  = "name"

  attribute = [
    {
      name = "name"
      type = "S"
    },
    {
      name = "type"
      type = "S"
    },
    {
      name = "score"
      type = "N"
    },
  ]

  global_secondary_index {
    name            = "tags-score"
    hash_key        = "type"
    range_key       = "score"
    projection_type = "ALL"
  }
}

resource "aws_dynamodb_table" "dynamodb_table_likes" {
  name = "${format("%s-likes", local.name)}"
  tags = "${local.tags}"

  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "thumb"
  range_key = "submniter"

  attribute = [
    {
      name = "submniter"
      type = "S"
    },
    {
      name = "thumb"
      type = "S"
    },
  ]
}
