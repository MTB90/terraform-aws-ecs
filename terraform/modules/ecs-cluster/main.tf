# Local variables
locals {
  module = "ecs"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

# ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${format("%s-cluster", local.name)}"
  tags = "${local.tags}"
}
