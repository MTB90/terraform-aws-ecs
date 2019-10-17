# Resources
resource "aws_lb" "alb" {
  name = var.tags["Name"]
  tags = var.tags

  internal = false
  security_groups = [aws_security_group.alb_sg.id]
  subnets = var.subnets
}

resource "aws_alb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_tg.arn
  }
}

resource "aws_alb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_security_group" "alb_sg" {
  name = format("%s-sg", var.tags["Name"])
  tags = var.tags

  # Inbound HTTPS
  ingress {
    protocol    = "TCP"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP
  ingress {
    protocol    = "TCP"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTPS
  ingress {
    protocol         = "TCP"
    from_port        = 443
    to_port          = 443
    ipv6_cidr_blocks = ["::/0"]
  }

  # Inbound HTTP
  ingress {
    protocol         = "TCP"
    from_port        = 80
    to_port          = 80
    ipv6_cidr_blocks = ["::/0"]
  }

  # Outbound
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc_id
}

resource "aws_alb_target_group" "alb_tg" {
  name = format("%s-tg", var.tags["Name"])
  tags = var.tags

  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}
