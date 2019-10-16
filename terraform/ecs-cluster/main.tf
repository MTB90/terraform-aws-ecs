provider "aws" {
  region = var.aws_region
}

terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}

  # The latest version of Terragrunt (v0.19.0 and above) requires Terraform 0.12.0 or above.
  required_version = ">= 0.12.0"
}

data "terraform_remote_state" "cognito" {
  backend = "s3"
  config = {
    region = var.tfstate_global_bucket_region
    bucket = var.tfstate_global_bucket
    key = format("%s/%s/cognito/terraform.tfstate", var.aws_region, var.aws_environment_type)
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    region = var.tfstate_global_bucket_region
    bucket = var.tfstate_global_bucket
    key = format("%s/%s/network/terraform.tfstate", var.aws_region, var.aws_environment_type)
  }
}

data "terraform_remote_state" "storage" {
  backend = "s3"
  config = {
    region = var.tfstate_global_bucket_region
    bucket = var.tfstate_global_bucket
    key = format("%s/%s/storage/terraform.tfstate", var.aws_region, var.aws_environment_type)
  }
}
