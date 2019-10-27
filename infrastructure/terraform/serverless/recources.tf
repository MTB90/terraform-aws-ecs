locals {
  name               = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags               = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
}

module "sns_s3_notification" {
  source     = "./sns-s3-event"
  tags       = merge(local.tags, map("Name", format("%s-sns-s3-event", local.name)))

  aws_region    = var.aws_region
  file_storage  = data.terraform_remote_state.storage.outputs.file_storage
}

data "template_file" "lambda_thumbnail_role" {
  template = file("${path.module}/lambda-thumbnail-role.json.tpl")

  vars = {
    storage = data.terraform_remote_state.storage.outputs.file_storage
  }
}

module "lambda_thumbnail" {
  source = "./lambda-sns"
  tags   = merge(local.tags, map("Name", format("%s-lambda-thumbnail", local.name)))

  lambda_handler   = "thumbnail.handler"
  lambda_source    = "${path.root}/../../../../../../../../photorec-serverless/thumbnail.zip"
  lambda_policy    = data.template_file.lambda_thumbnail_role.rendered
  lambda_variables = {
    STORAGE = data.terraform_remote_state.storage.outputs.file_storage
  }

  sns_arn          = module.sns_s3_notification.arn
}

data "template_file" "lambda_rekognition_role" {
  template = file("${path.module}/lambda-rekognition-role.json.tpl")

  vars = {
    storage = data.terraform_remote_state.storage.outputs.file_storage
  }
}

module "lambda_rekognition" {
  source = "./lambda-sns"
  tags   = merge(local.tags, map("Name", format("%s-lambda-rekognition", local.name)))

  lambda_handler   = "rekognition.handler"
  lambda_source    = "${path.root}/../../../../../../../../photorec-serverless/rekognition.zip"
  lambda_policy    = data.template_file.lambda_rekognition_role.rendered
  lambda_variables = {
    DATABASE = data.terraform_remote_state.storage.outputs.database
    STORAGE  = data.terraform_remote_state.storage.outputs.file_storage
    REGION   = var.aws_region
  }

  sns_arn          = module.sns_s3_notification.arn
}