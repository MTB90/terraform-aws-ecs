provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "edx-developer"
    key    = "terraform-state/terraform.tfstate"
    region = "eu-west-1"
  }

  required_version = "~>0.11.0"
}