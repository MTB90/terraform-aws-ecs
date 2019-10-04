# Dynamodb
module "dynamodb" {
  source = "../modules/dynamodb"
  tags   = var.tags
}

# S3
module "s3" {
  source = "../modules/s3"
  tags   = var.tags
}