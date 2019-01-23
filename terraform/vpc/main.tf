# Local variables
locals {
  module = "vpc"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
}

locals {
  tags = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

# Resources
resource "aws_vpc" "vpc" {
  tags       = "${local.tags}"
  cidr_block = "${var.cidr}"
}

module "subnet_public" {
  source = "../subnet-layer"
  tags   = "${merge(var.tags, map("Name", "public"))}"

  public = true
  vpc_id = "${aws_vpc.vpc.id}"
  azs    = "${var.azs}"
  cidr   = "${var.cidr}"
  shift  = 0
}

module "subnet_app" {
  source = "../subnet-layer"
  tags   = "${merge(var.tags, map("Name", "app"))}"

  vpc_id = "${aws_vpc.vpc.id}"
  azs    = "${var.azs}"
  cidr   = "${var.cidr}"
  shift  = "${length(var.azs)}"
}

module "subnet_db" {
  source = "../subnet-layer"
  tags   = "${merge(var.tags, map("Name", "db"))}"

  vpc_id = "${aws_vpc.vpc.id}"
  azs    = "${var.azs}"
  cidr   = "${var.cidr}"
  shift  = "${2 * length(var.azs)}"
}
