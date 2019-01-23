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
  tags                 = "${local.tags}"
  cidr_block           = "${var.cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  tags   = "${local.tags}"
  vpc_id = "${aws_vpc.vpc.id}"
}
