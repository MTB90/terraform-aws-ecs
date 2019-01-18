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
  tags                 = "${local.tags}"
  cidr_block           = "${var.cidr}"
}
