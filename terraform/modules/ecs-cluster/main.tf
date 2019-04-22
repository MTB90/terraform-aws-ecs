# Local variables
locals {
  module = "ecs-cluster"
  name   = "${format("%s-%s", var.tags["Project"], var.tags["Envarioment"])}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

# Resources
resource "aws_ecs_cluster" "cluster" {
  name = "${format("%s-cluster", local.name)}"
  tags = "${local.tags}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.tpl")}"

  vars = {
    cluster = "${aws_ecs_cluster.cluster.name}"
    region  = "${var.region}"
    prefix  = "${format("%s/ec2", var.tags["Project"])}"
  }
}
