# Resources
resource "aws_launch_configuration" "config" {
  name = var.tags["Name"]

  image_id      = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.config_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  user_data                   = var.user_data
  key_name                    = var.key_name
  associate_public_ip_address = false
}

resource "aws_security_group" "config_sg" {
  name = format("%s-sg", var.tags["Name"])
  tags = merge(var.tags, map("Name", format("%s-sg", var.tags["Name"])))

  # Inbound ALB
  ingress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    security_groups = [var.alb_sg_id]
  }

  # Inbound Bastion
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [var.bastion_sg_id]
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
  name = format("%s-iam-instance-profile", var.tags["Name"])
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name               = format("%s-iam-role", var.tags["Name"])
  tags               = merge(var.tags, map("Name", format("%s-iam-role", var.tags["Name"])))
  assume_role_policy = file("${path.module}/policies/assume-role.json")
}

resource "aws_iam_role_policy_attachment" "constiner_instance_policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.container_instance_policy.arn
}

resource "aws_iam_policy" "container_instance_policy" {
  name        = format("%s-container-instance-policy", var.tags["Name"])
  path        = "/"
  description = "Policy for the Amazon EC2 Role for Amazon EC2 Container instance."

  policy = data.template_file.template_instance_role.rendered
}

data "template_file" "template_instance_role" {
  template = file("${path.module}/policies/container-instance-role.json.tpl")

  vars = {
    storage = var.file_storage
  }
}
