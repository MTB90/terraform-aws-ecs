output "ecs_launch_config_sg_id" {
  value = "${aws_security_group.launch_configuration_sg.id}"
}
