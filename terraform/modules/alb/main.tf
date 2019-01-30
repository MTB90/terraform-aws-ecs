# Local variables
locals {
  module = "alb"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

# Resources
resource "aws_alb" "alb" {
  name = "${local.name}"
  tags = "${local.tags}"

  internal        = false
  security_groups = ["${aws_security_group.alb_sg.id}"]
  subnets         = ["${var.subnets}"]
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = 80
  protocol          = "HTTP"

  "default_action" {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_tg.arn}"
  }
}

resource "aws_security_group" "alb_sg" {
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

resource "aws_alb_target_group" "alb_tg" {
  name = "${format("%s-tg", local.name)}"
  tags = "${local.tags}"

  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${var.vpc_id}"
}
