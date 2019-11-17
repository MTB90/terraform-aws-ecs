output "arn" {
  value = aws_ecs_task_definition.task_definition.arn
}

output "container_name" {
  value = var.tags["Name"]
}
