# Local variables
locals {
  module      = "app-autoscaling"
  name        = "${format("%s-%s", var.tags["Project"] ,local.module)}"
  tags        = "${merge(var.tags, map("Module", local.module))}"
  resource_id = "${format("service/%s/%s", var.cluster_name ,var.service_name)}"
}

# Resources
resource "aws_appautoscaling_target" "ecs_app_target" {
  max_capacity = "${var.capacity_limits["max"]}"
  min_capacity = "${var.capacity_limits["min"]}"

  resource_id = "${local.resource_id}"

  role_arn           = "${aws_iam_policy.app_autoscaling_service_policy.arn}"
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

resource "aws_iam_role" "role_app_autoscaling" {
  name               = "${format("%s-iam-role", local.name)}"
  tags               = "${local.tags}"
  assume_role_policy = "${file("${path.module}/policies/assume-role.json")}"
}

resource "aws_iam_role_policy_attachment" "role_app_autoscaling_policy_attachment" {
  role       = "${aws_iam_role.role_app_autoscaling.name}"
  policy_arn = "${aws_iam_policy.app_autoscaling_service_policy.arn}"
}

resource "aws_iam_policy" "app_autoscaling_service_policy" {
  name        = "${format("%s-ec2-container-service", local.name)}"
  path        = "/"
  description = "Policy for the app for app autoscaling."

  policy = "${file("${path.module}/policies/app-autoscaling-role.json")}"
}
