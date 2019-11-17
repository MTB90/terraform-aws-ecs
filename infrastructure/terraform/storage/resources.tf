# Dynamodb
module "dynamodb" {
  source = "./dynamodb"
  tags   = merge(local.tags, map("Name", format("%s-dynamodb", local.prefix)))
}

resource "aws_ssm_parameter" "database_name_parameter" {
  name = format("%s-database-name", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-database-name", local.prefix)))

  type  = "String"
  value = format("%s-dynamodb", local.prefix)
}

# S3
module "storage" {
  source = "./s3"
  tags   = merge(local.tags, map("Name", format("%s-s3", local.prefix)))
}

resource "aws_ssm_parameter" "file_strorage_parameter" {
  name = format("%s-file-storage", local.prefix)
  tags = merge(local.tags, map("Name", format("%s-file-storage", local.prefix)))

  type  = "String"
  value = format("%s-s3", local.prefix)
}
