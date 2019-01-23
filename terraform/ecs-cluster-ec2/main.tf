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
resource "aws_iam_role" "ecs_iam_role" {
  name = "${format("%s-iam-role", local.name)}"
  tags = "${local.tags}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
  }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_iam_role_attachment" {
  role       = "${aws_iam_role.ecs_iam_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_iam_instance_profile" {
  name = "${format("%s-iam-instance-profile", local.name)}"
  role = "${aws_iam_role.ecs_iam_role.name}"
}

resource "aws_security_group" "ecs_launch_configuration_sg" {
  name   = "${format("%s-launch-config-sg", local.name)}"
  tags   = "${merge(var.tags, map("Name", format("%s-launch-config-sg", local.name)))}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_launch_configuration" "ecs_launch_configuration" {
  name = "${format("%s-launch-config", local.name)}"

  image_id             = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.ecs_launch_configuration_sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs_iam_instance_profile.id}"
}

# Auto scaling group
resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  max_size             = 6
  min_size             = 1
  desired_capacity     = 3
  health_check_type    = "EC2"
  vpc_zone_identifier  = ["${var.subnets}"]
  launch_configuration = "${aws_launch_configuration.ecs_launch_configuration.id}"
}
