locals {
  name  = format("%s-%s", var.aws_project_name, var.aws_environment_type)
}

resource "aws_lambda_layer_version" "lambda_layer_pillow" {
  filename   = "${path.root}/../../../../../../../../photorec-serverless/pillow.zip"
  layer_name = format("%s-lambda-layer-pill", local.name)

  compatible_runtimes = ["python3.7"]
  source_code_hash    = filebase64sha256("${path.root}/../../../../../../../../photorec-serverless/pillow.zip")
}
