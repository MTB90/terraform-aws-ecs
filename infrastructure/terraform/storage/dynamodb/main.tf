resource "aws_dynamodb_table" "dynamodb_table_photos" {
  name = format("%s-photos", var.tags["Name"])
  tags = var.tags

  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "photo"

  attribute {
    name = "photo"
    type = "S"
  }
  attribute {
    name = "nickname"
    type = "S"
  }

  attribute {
    name = "tag"
    type = "S"
  }

  attribute {
    name = "likes"
    type = "N"
  }

  global_secondary_index {
    name            = "photo-nickname"
    hash_key        = "nickname"
    range_key       = "likes"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "photo-tags"
    hash_key        = "tag"
    range_key       = "likes"
    projection_type = "ALL"
  }
}

resource "aws_dynamodb_table" "dynamodb_table_tags" {
  name = format("%s-tags", var.tags["Name"])
  tags = var.tags

  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "tag"

  attribute {
    name = "tag"
    type = "S"
  }
  attribute {
    name = "tags"
    type = "S"
  }
  attribute {
    name = "score"
    type = "N"
  }

  global_secondary_index {
    name            = "tags-score"
    hash_key        = "tags"
    range_key       = "score"
    projection_type = "ALL"
  }
}

resource "aws_dynamodb_table" "dynamodb_table_likes" {
  name = format("%s-likes", var.tags["Name"])
  tags = var.tags

  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "thumbnail"
  range_key = "submitter"

  attribute {
    name = "submitter"
    type = "S"
  }
  attribute {
    name = "thumbnail"
    type = "S"
  }
}
