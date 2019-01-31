output "user_data" {
  value = "${data.template_file.user_data.rendered}"
}

output "name" {
  value = "${aws_ecs_cluster.cluster.name}"
}

output "id" {
  value = "${aws_ecs_cluster.cluster.id}"
}
