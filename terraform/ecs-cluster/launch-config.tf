# Lanunch configuration
resource "aws_launch_configuration" "ecs_launch_configuration" {
  name = "${format("%s-launch-config", local.name)}"

  image_id             = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.ecs_launch_configuration_sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs_iam_instance_profile.id}"

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=photorec-ecs-cluster-ec2 >> /etc/ecs/ecs.config;
echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
EOF
}

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
