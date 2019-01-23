# Auto scaling group
resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                 = "${format("%s-autoscaling-group", local.name)}"
  max_size             = 6
  min_size             = 1
  desired_capacity     = 3
  health_check_type    = "EC2"
  vpc_zone_identifier  = ["${var.subnets}"]
  launch_configuration = "${aws_launch_configuration.ecs_launch_configuration.id}"
}
