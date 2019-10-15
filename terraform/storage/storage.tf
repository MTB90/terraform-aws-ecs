locals {
  name = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
}

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