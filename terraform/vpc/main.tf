# Local variables
locals {
  module = "vpc"
  name   = "${format("%s-%s-%s", var.tags["Project"] ,local.module, var.tags["Name"])}"
}

locals {
  tags = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

# Resources
resource "aws_vpc" "vpc" {
  tags       = "${local.tags}"
  cidr_block = "${var.cidr}"
}

resource "aws_internet_gateway" "igw" {
  tags   = "${local.tags}"
  vpc_id = "${aws_vpc.vpc.id}"
}

module "subnet_public" {
  source = "./subnet_layer"
  tags   = "${merge(var.tags, map("Name", "public"))}"

  vpc_id = "${aws_vpc.vpc.id}"
  cidr   = "${var.cidr}"
  shift  = 0
  public = true
  igw    = "${aws_internet_gateway.igw.id}"
  azs    = "${var.azs}"
}

module "subnet_app" {
  source = "./subnet_layer"
  tags   = "${merge(var.tags, map("Name", "app"))}"

  vpc_id = "${aws_vpc.vpc.id}"
  cidr   = "${var.cidr}"
  shift  = "${length(var.azs)}"
  azs    = "${var.azs}"
}

module "subnet_db" {
  source = "./subnet_layer"
  tags   = "${merge(var.tags, map("Name", "db"))}"

  vpc_id = "${aws_vpc.vpc.id}"
  cidr   = "${var.cidr}"
  shift  = "${2 * length(var.azs)}"
  azs    = "${var.azs}"
}
