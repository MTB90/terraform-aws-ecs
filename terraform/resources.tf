data "aws_availability_zones" "available" {}

module "vpc" {
  source = "./vpc"
  tags   = "${merge(var.project_tags, map("Name", "vpc"))}"

  cidr = "${var.network_address_space}"
  azs  = "${data.aws_availability_zones.available.names}"
}
