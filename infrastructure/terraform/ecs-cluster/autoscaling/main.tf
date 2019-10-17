# Resources
resource "aws_autoscaling_group" "autoscaling_group" {
  name = var.tags["Name"]

  tags = [
    {
      key                 = "Name"
      value               = var.tags["Name"]
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = var.tags["Project"]
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = var.tags["Environment"]
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
  name = format("%s-policy", var.tags["Name"])

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
