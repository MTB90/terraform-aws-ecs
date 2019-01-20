# Local variables
locals {
  module = "subnet_layer"
  name   = "${format("%s-%s-%s", var.tags["Project"] ,local.module, var.tags["Name"])}"
}

locals {
  tags = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

# Resources
resource "aws_route_table" "route_table" {
  tags   = "${local.tags}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_route" "route" {
  count                  = "${var.public ? 1 : 0}"
  route_table_id         = "${aws_route_table.route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${var.igw}"
}

resource "aws_subnet" "subnet" {
  tags = "${local.tags}"

  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${cidrsubnet(var.cidr, 8, var.shift + count.index)}"
  availability_zone       = "${element(var.azs, count.index)}"
  count                   = "${length(var.azs)}"
  map_public_ip_on_launch = "true"
}

resource "aws_route_table_association" "route_table_association" {
  count          = "${length(var.azs)}"
  subnet_id      = "${element(aws_subnet.subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.route_table.id}"
}
