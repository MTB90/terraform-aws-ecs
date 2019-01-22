# Local variables
locals {
  module = "ecs"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
}

locals {
  tags = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

# ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${format("%s-cluster-ec2", local.name)}"
  tags = "${local.tags}"
}

# Lanunch configuration
resource "aws_security_group" "ecs_launch_configuration_sg" {
  name = "${format("%s-launch-config-sg", local.name)}"
  tags = "${merge(var.tags, map("Name", format("%s-launch-config-sg", local.name)))}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_launch_configuration" "ecs_launch_configuration" {
  name = "${format("%s-launch-config", local.name)}"

  image_id        = "${var.image_id}"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.ecs_launch_configuration_sg.id}"]
}

# Auto scaling group
resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  max_size            = 6
  min_size            = 1
  desired_capacity    = 3
  health_check_type   = "EC2"
  vpc_zone_identifier = ["${var.subnets}"]
  launch_configuration = "${aws_launch_configuration.ecs_launch_configuration.id}"
}
