# Local variables
locals {
  module = "ecs-cluster"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

# ECS cluster
resource "aws_ecs_cluster" "cluster" {
  name = "${format("%s-cluster", local.name)}"
  tags = "${local.tags}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.tpl")}"

  vars = {
    cluster = "${aws_ecs_cluster.cluster.name}"
  }
}
