# Launch configuration
resource "aws_launch_configuration" "ecs_launch_configuration" {
  name = "${format("%s-launch-config", local.name)}"

  image_id             = "${var.image_id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.launch_configuration_sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.iam_instance_profile.id}"

  user_data = "${data.template_file.user_data.rendered}"
}

# Security group for launch confuguration
resource "aws_security_group" "launch_configuration_sg" {
  name = "${format("%s-launch-config-sg", local.name)}"
  tags = "${merge(var.tags, map("Name", format("%s-launch-config-sg", local.name)))}"

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

# IAM instance profile for launch configuration
resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "${format("%s-iam-instance-profile", local.name)}"
  role = "${aws_iam_role.iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "iam_role_attachment" {
  role       = "${aws_iam_role.iam_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "iam_role" {
  name = "${format("%s-iam-role", local.name)}"
  tags = "${local.tags}"

  assume_role_policy = "${data.aws_iam_policy_document.assume_policy_document.json}"
}

data "aws_iam_policy_document" "assume_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# User data file
data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.tpl")}"

  vars = {
    cluster = "${aws_ecs_cluster.ecs_cluster.name}"
  }
}
