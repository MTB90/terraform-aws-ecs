locals {
  name               = format("%s-%s", var.aws_project_name, var.aws_environment_type)
  tags               = merge(map("Project", var.aws_project_name, "Environment", var.aws_environment_type))
}


module "lambda_thumbnail" {
  source = "./lambda-thumbnail"
  tags   = merge(local.tags, map("Name", format("%s-lambda-thumbnail", local.name)))

  lambda_handler = "thumbnail.handler"
  lambda_source  = "${path.root}/../../../../../../../../photorec-serverless/thumbnail.zip"
  file_storage   = data.terraform_remote_state.storage.outputs.file_storage
}