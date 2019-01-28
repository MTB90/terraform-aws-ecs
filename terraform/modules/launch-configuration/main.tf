# Local variables
locals {
  module = "launch-config"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module))}"
}

resource "aws_launch_configuration" "config" {
  name = "${local.name}"

  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  security_groups             = ["${aws_security_group.config_sg.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.instance_profile.arn}"
  user_data                   = "${var.user_data}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = false
}

# Security group
resource "aws_security_group" "config_sg" {
  name = "${format("%s-sg", local.name)}"
  tags = "${merge(var.tags, map("Name", format("%s-sg", local.name)))}"

  # Inbound HTTP
  ingress {
    protocol        = "TCP"
    from_port       = 22
    to_port         = 22
    security_groups = ["${var.sq_inbound_rule}"]
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
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${format("%s-iam-instance-profile", local.name)}"
  role = "${aws_iam_role.role.name}"
}

resource "aws_iam_role" "role" {
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
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_constiner_service_policy_attachment" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "cloud_watch_logs_policy_attachment" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${aws_iam_policy.cloud_watch_logs_policy.arn}"
}

resource "aws_iam_policy" "cloud_watch_logs_policy" {
  name = "${format("%s-cloud-watch-logs", local.name)}"
  path = "/"
  description = "My test policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
EOF
}
