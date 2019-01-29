# Local variables
locals {
  module = "ecs-service"
  name   = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

# Resources
resource "aws_ecs_service" "ecs_service" {
  name = "${local.name}"

  desired_count   = 3
  launch_type     = "EC2"
  cluster         = "${var.cluster_id}"
  task_definition = "${var.task_definition_arn}"

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  network_configuration {
    subnets         = ["${var.subnets}"]
    security_groups = ["${aws_security_group.ecs_service_sg.id}"]
  }
}

resource "aws_security_group" "ecs_service_sg" {
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
