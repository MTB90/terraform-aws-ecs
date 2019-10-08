# Local variables
locals {
  module = "ec2-autoscaling-group"
  name   = format("%s-%s-%s", var.tags["Project"], var.tags["Envarioment"], local.module)
  tags   = merge(var.tags, map("Module", local.module, "Name", local.name))
}

# Resources
resource "aws_autoscaling_group" "autoscaling_group" {
  name = local.name

  tags = [
    {
      key                 = "Name"
      value               = local.name
      propagate_at_launch = true
    },
    {
      key                 = "Module"
      value               = local.tags["Module"]
      propagate_at_launch = true
    },
  ]

  max_size         = var.capacity_limits["max"]
  min_size         = var.capacity_limits["min"]
  desired_capacity = var.capacity_limits["desired"]

  health_check_type = "EC2"
  vpc_zone_identifier = var.subnets
  launch_configuration = var.launch_configuration_id
}

resource "aws_autoscaling_policy" "autoscaling_policy" {
  name = format("%s-policy", local.module)

  autoscaling_group_name    = aws_autoscaling_group.autoscaling_group.name
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}
