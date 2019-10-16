output "sg_id" {
  value = aws_security_group.config_sg.id
}

output "id" {
  value = aws_launch_configuration.config.id
}
