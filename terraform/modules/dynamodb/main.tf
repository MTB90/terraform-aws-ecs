# Local variables
locals {
  module   = "dynamodb"
  database = "${format("%s-%s", var.tags["Project"], var.tags["Envarioment"])}"
  tags     = "${merge(var.tags, map("Module", local.module, "Name", local.database))}"
}

resource "aws_dynamodb_table" "dynamodb_table_photos" {
  name = "${format("%s-photos", local.database)}"
  tags = "${local.tags}"

  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "nickname"
  range_key = "uuid"

  attribute = [
    {
      name = "nickname"
      type = "S"
    },
    {
      name = "uuid"
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
  name = "${format("%s-tags", local.database)}"
  tags = "${local.tags}"

  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "name"

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
  name = "${format("%s-likes", local.database)}"
  tags = "${local.tags}"

  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "thumb"
  range_key = "submitter"

  attribute = [
    {
      name = "submitter"
      type = "S"
    },
    {
      name = "thumb"
      type = "S"
    },
  ]
}
