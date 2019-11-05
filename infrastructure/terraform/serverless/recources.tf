locals {
  prefix = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags   = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
}

data "aws_s3_bucket" "file_storage" {
  bucket = format("%s-%s-s3", var.aws_project_name, var.aws_environment_type)
}

module "sns_s3_notification" {
  source = "./sns-s3-event"
  tags   = merge(local.tags, map("Name", format("%s-sns-s3-event", local.prefix)))

  aws_region   = var.aws_region
  file_storage = data.aws_s3_bucket.file_storage.bucket
}

data "template_file" "lambda_thumbnail_role" {
  template = file("${path.module}/lambda-thumbnail-role.json.tpl")

  vars = {
    storage = data.aws_s3_bucket.file_storage.bucket
  }
}

module "lambda_thumbnail" {
  source = "./lambda-sns"
  tags   = merge(local.tags, map("Name", format("%s-lambda-thumbnail", local.prefix)))

  lambda_handler = "thumbnail.handler"
  lambda_source  = "${path.root}/../../../../../../../../photorec-serverless/thumbnail.zip"
  lambda_policy  = data.template_file.lambda_thumbnail_role.rendered
  lambda_variables = {
    STORAGE = data.aws_s3_bucket.file_storage.bucket
  }

  sns_arn = module.sns_s3_notification.arn
}

data "template_file" "lambda_rekognition_role" {
  template = file("${path.module}/lambda-rekognition-role.json.tpl")

  vars = {
    storage = data.aws_s3_bucket.file_storage.bucket
  }
}

module "lambda_rekognition" {
  source = "./lambda-sns"
  tags   = merge(local.tags, map("Name", format("%s-lambda-rekognition", local.prefix)))

  lambda_handler = "rekognition.handler"
  lambda_source  = "${path.root}/../../../../../../../../photorec-serverless/rekognition.zip"
  lambda_policy  = data.template_file.lambda_rekognition_role.rendered
  lambda_variables = {
    DATABASE = format("%s-%s-dynamodb", var.aws_project_name, var.aws_environment_type)
    STORAGE  = data.aws_s3_bucket.file_storage.bucket
    REGION   = var.aws_region
  }

  sns_arn = module.sns_s3_notification.arn
}