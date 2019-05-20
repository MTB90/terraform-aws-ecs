# Local variables
locals {
  module = "ecs-service"
  name   = "${format("%s-%s-%s", var.tags["Project"], var.tags["Envarioment"], local.module)}"
  tags   = "${merge(var.tags, map("Module", local.module, "Name", local.name))}"
}

# Resources
resource "aws_ecs_service" "ecs_service" {
  name = "${local.name}"

  launch_type         = "EC2"
  cluster             = "${var.cluster_id}"
  task_definition     = "${var.task_definition_arn}"
  scheduling_strategy = "REPLICA"

  desired_count = "${var.capacity_limits["desired"]}"

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
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

resource "null_resource" "alb_exists" {
  triggers {
    alb_name = "${var.alb_arn}"
  }
}
