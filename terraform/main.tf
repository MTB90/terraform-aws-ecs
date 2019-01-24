provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "photorec"
    key    = "terraform-state/terraform.tfstate"
    region = "us-west-2"
  }

  required_version = "~>0.11.0"
}
