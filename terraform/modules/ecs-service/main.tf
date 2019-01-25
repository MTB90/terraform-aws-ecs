# Local variables
locals {
  module = "ecs-service"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}
