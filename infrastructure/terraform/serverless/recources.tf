module "lambda_thumbnail" {
  source = "./lambda-sns"
  tags   = merge(local.tags, map("Name", format("%s-lambda-thumbnail", local.prefix)))

  lambda_handler = "thumbnail.handler"
  lambda_source  = "${path.root}/../../../../../../../../serverless/thumbnail.zip"
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
  lambda_source  = "${path.root}/../../../../../../../../serverless/rekognition.zip"
  lambda_policy  = data.template_file.lambda_rekognition_role.rendered
  lambda_variables = {
    DATABASE = format("%s-%s-dynamodb", var.aws_project_name, var.aws_environment_type)
    STORAGE  = data.aws_s3_bucket.file_storage.bucket
    REGION   = var.aws_region
  }

  sns_arn = module.sns_s3_notification.arn
}