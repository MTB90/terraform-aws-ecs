# Local variables
locals {
  module = "igw"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

resource "aws_internet_gateway" "igw" {
  tags   = "${var.tags}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_route" "route_igw" {
  route_table_id         = "${var.route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}
