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

# ECS lanuch configuration
module "ecs_launch_config" {
  source = "../ecs-launch-config"
  tags   = "${var.tags}"

  vpc_id        = "${var.vpc_id}"
  image_id      = "${var.image_id}"
  instance_type = "${var.instance_type}"
}

# Auto scaling group
resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  max_size             = 6
  min_size             = 1
  desired_capacity     = 3
  health_check_type    = "EC2"
  vpc_zone_identifier  = ["${var.subnets}"]
  launch_configuration = "${module.ecs_launch_config.ecs_launch_configuration_id}"
}
