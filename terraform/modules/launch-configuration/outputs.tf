output "sg_id" {
  value = "${aws_security_group.sg.id}"
}

output "id" {
  value = "${aws_launch_configuration.config.id}"
}
