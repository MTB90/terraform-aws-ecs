# Dynamodb
module "dynamodb" {
  source = "./dynamodb"
  tags   = merge(local.tags, map("Name", format("%s-dynamodb", local.name)))
}

# S3
module "storage" {
  source = "./s3"
  tags   = merge(local.tags, map("Name", format("%s-s3", local.name)))
}