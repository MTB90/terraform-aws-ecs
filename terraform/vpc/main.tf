# Local variables
locals {
  module      = "vpc"
  perfix_name = "${format("%s-%s",var.tags["Name"], local.module)}"
}

locals {
  tags = "${merge(var.tags, map("Module", local.module, "Name", local.perfix_name))}"
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

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = "${merge(local.tags, map("Name", format("%s-public", local.tags["Name"])))}"
}

resource "aws_route_table" "app" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(local.tags, map("Name", format("%s-app", local.tags["Name"])))}"
}

resource "aws_route_table" "db" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(local.tags, map("Name", format("%s-db", local.tags["Name"])))}"
}

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr, 8, count.index)}"
  availability_zone       = "${element(var.azs, count.index)}"
  count                   = "${length(var.azs)}"
  map_public_ip_on_launch = "true"

  tags = "${merge(local.tags,
          map("Name", format("%s-public-subnet-%d", local.tags["Name"], count.index)))}"
}

resource "aws_subnet" "app" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${cidrsubnet(var.cidr, 8, length(var.azs) + count.index)}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.azs)}"

  tags = "${merge(local.tags,
          map("Name", format("%s-app-subnet-%d", local.tags["Name"], count.index)))}"
}

resource "aws_subnet" "db" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${cidrsubnet(var.cidr, 8, 2 * length(var.azs) + count.index)}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.azs)}"

  tags = "${merge(local.tags,
          map("Name", format("%s-db-subnet-%d", local.tags["Name"], count.index)))}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.azs)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "app" {
  count          = "${length(var.azs)}"
  subnet_id      = "${element(aws_subnet.app.*.id, count.index)}"
  route_table_id = "${aws_route_table.app.id}"
}

resource "aws_route_table_association" "db" {
  count          = "${length(var.azs)}"
  subnet_id      = "${element(aws_subnet.db.*.id, count.index)}"
  route_table_id = "${aws_route_table.db.id}"
}