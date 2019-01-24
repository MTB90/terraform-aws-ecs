# Local variables
locals {
  module = "launch-config"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module))}"
}

resource "aws_launch_configuration" "config" {
  name = "${local.name}"

  image_id             = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.config_sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.config_instance_profile.arn}"
  user_data            = "${var.user_data}"
}

# Security group
resource "aws_security_group" "config_sg" {
  name = "${format("%s-sg", local.name)}"
  tags = "${merge(var.tags, map("Name", format("%s-sg", local.name)))}"

  # Inbound HTTP
  ingress {
    protocol    = "TCP"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"
}

# IAM
resource "aws_iam_instance_profile" "config_instance_profile" {
  name = "${format("%s-iam-instance-profile", local.name)}"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role_policy_attachment" "config_role_attachment" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "role" {
  name = "${format("%s-iam-role", local.name)}"
  tags = "${local.tags}"

  assume_role_policy = "${data.aws_iam_policy_document.config_assume_policy_document.json}"
}

data "aws_iam_policy_document" "config_assume_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
