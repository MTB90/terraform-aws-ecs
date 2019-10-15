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

  aws_admin_inbound_rule  = "0.0.0.0/0"
  aws_admin_key_pair_name = "bastion"

  tfstate_global_bucket        = "photorec-infrastracture"
  tfstate_global_bucket_region = "eu-west-1"
}
