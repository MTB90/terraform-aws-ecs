# Local variables
locals {
  module = "ec2-launch-config"
  name   = format("%s-%s-%s", var.tags["Project"], var.tags["Envarioment"], local.module)
  tags   = merge(var.tags, map("Module", local.module))
}

# Resources
resource "aws_launch_configuration" "config" {
  name = local.name

  image_id      = var.image_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.config_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  user_data                   = var.user_data
  key_name                    = var.key_name
  associate_public_ip_address = false
}

resource "aws_security_group" "config_sg" {
  name = format("%s-sg", local.name)
  tags = merge(var.tags, map("Name", format("%s-sg", local.name)))

  # Inbound ALB
  ingress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    security_groups = [var.sq_inbound_rule]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc_id
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = format("%s-iam-instance-profile", local.name)
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name               = format("%s-iam-role", local.name)
  tags               = local.tags
  assume_role_policy = file("${path.module}/policies/assume-role.json")
}

resource "aws_iam_role_policy_attachment" "constiner_instance_policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.container_instance_policy.arn
}

resource "aws_iam_policy" "container_instance_policy" {
  name        = format("%s-container-instance-policy", local.name)
  path        = "/"
  description = "Policy for the Amazon EC2 Role for Amazon EC2 Container instance."

  policy = data.template_file.template_instance_role.rendered
}

data "template_file" "template_instance_role" {
  template = file("${path.module}/policies/container-instance-role.json.tpl")

  vars {
    storage = var.storage
  }
}
