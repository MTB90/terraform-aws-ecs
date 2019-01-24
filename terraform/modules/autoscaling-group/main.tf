# Local variables
locals {
  module = "autoscaling-group"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name = "${local.name}"

  max_size             = 6
  min_size             = 1
  desired_capacity     = 3
  health_check_type    = "EC2"
  vpc_zone_identifier  = ["${var.subnets}"]
  launch_configuration = "${var.launch_configuration_id}"
}
