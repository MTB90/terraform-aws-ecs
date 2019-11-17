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