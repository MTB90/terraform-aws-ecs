# Local variables
locals {
  module      = "app-autoscaling"
  name        = "${format("%s-%s", var.tags["Project"], var.tags["Envarioment"])}"
  tags        = "${merge(var.tags, map("Module", local.module))}"
  resource_id = "${format("service/%s/%s", var.cluster_name ,var.service_name)}"
}

# Resources
resource "aws_appautoscaling_target" "ecs_app_target" {
  max_capacity = "${var.capacity_limits["max"]}"
  min_capacity = "${var.capacity_limits["min"]}"

  resource_id = "${local.resource_id}"

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_app_policy" {
  name               = "${local.name}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "${local.resource_id}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 50.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }

  depends_on = ["aws_appautoscaling_target.ecs_app_target"]
}
