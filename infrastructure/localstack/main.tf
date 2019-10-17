provider "aws" {
  region = var.aws_region

  s3_force_path_style         = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_credentials_validation = true

  access_key = "access_key"
  secret_key = "secret_key"

  endpoints {
    s3       = "http://127.0.0.1:4572"
    dynamodb = "http://127.0.0.1:4569"
  }
}

locals {
  name = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
}

# Dynamodb
module "dynamodb" {
  source = "../terraform/storage/dynamodb"
  tags   =  merge(local.tags, map("Name", local.name))
}

# S3
module "s3" {
  source = "../terraform/storage/s3"
  tags   = merge(local.tags, map("Name", local.name))
}
