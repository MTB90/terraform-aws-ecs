# Local variables
locals {
  module = "ecs-service"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

# Resources
resource "aws_ecs_service" "ecs_service" {
  name = "${local.name}"

  launch_type         = "EC2"
  cluster             = "${var.cluster_id}"
  task_definition     = "${var.task_definition_arn}"
  scheduling_strategy = "DAEMON"

  network_configuration {
    subnets         = ["${var.subnets}"]
    security_groups = ["${aws_security_group.ecs_service_sg.id}"]
  }

  load_balancer {
    target_group_arn = "${var.tg_arn}"
    container_name   = "${var.container_name}"
    container_port   = 8080
  }

  # By depending on the null_resource,
  # this resource effectively depends on the ALB existing.
  depends_on = ["null_resource.alb_exists"]
}

resource "aws_security_group" "ecs_service_sg" {
  name = "${format("%s-sg", local.name)}"
  tags = "${merge(var.tags, map("Name", format("%s-sg", local.name)))}"

  # Inbound ALB
  ingress {
    protocol        = "-1"
    from_port       = 0
    to_port         = 0
    security_groups = ["${var.alb_sg}"]
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

resource "null_resource" "alb_exists" {
  triggers {
    alb_name = "${var.alb_arn}"
  }
}

