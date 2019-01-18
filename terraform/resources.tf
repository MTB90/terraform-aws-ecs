data "aws_availability_zones" "available" {}

module "vpc" {
  source = "./vpc"
  tags   = "${var.project_tags}"

  cidr            = "${var.network_address_space}"
  azs             = "${data.aws_availability_zones.available.names}"
}