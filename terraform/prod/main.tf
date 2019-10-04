provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "photorec"
    key    = "terraform-state/terraform-prod.tfstate"
    region = "eu-west-1"
  }

  required_version = "~>0.12.9"
}
