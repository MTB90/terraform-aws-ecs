remote_state {
  backend = "s3"

  config = {
    encrypt        = true
    bucket         = "photorec-infrastracture"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-west-1"
  }
}

inputs = {
  domian_name               = "photorec.ml"

  aws_project_name          = "photorec"
  aws_environment_type      = "prod"

  tfstate_global_bucket        = "photorec-infrastracture"
  tfstate_global_bucket_region = "eu-west-1"
}
